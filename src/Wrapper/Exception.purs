{-
エラー処理！
-}
module Src.Wrapper.Exception where

import Prelude
import Affjax as AX
import Control.Monad.Error.Class (class MonadError, class MonadThrow)
import Control.Monad.Except (class MonadTrans, lift)
import Control.Monad.Except as Except
import Data.Either (Either(..), either)
import Data.Foldable (fold)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Exception as Exception
import Foreign as F

-- | エラー型
data Error
  = JSError Exception.Error --Javascriptのエラー
  | AXError AX.Error --Affjaxのエラー
  | ForeignMultiError F.MultipleErrors -- Foreign.Genericのエラー
  | NotLoginError --ログインしていない
  | WrongPasswordError --パスワードが違う

-- | Src.Wrapper.Exception.Error型に特化したExceptT(名前を変えた方が良い？)
data ExceptT m a
  = ExceptT (m (Either Error a))

instance showError :: Show Error where
  show = case _ of
    JSError err -> show err
    AXError err -> AX.printError err
    ForeignMultiError err -> fold <<< map F.renderForeignError $ err
    NotLoginError -> "Please Login"
    WrongPasswordError -> "Wrong Password!"

instance functorExceptT :: Functor m => Functor (ExceptT m) where
  map f (ExceptT x) = ExceptT $ map f <$> x

instance applyExceptT :: Apply m => Apply (ExceptT m) where
  apply (ExceptT f) (ExceptT x) = ExceptT $ apply <$> f <*> x

instance applicativeExceptT :: Applicative m => Applicative (ExceptT m) where
  pure = ExceptT <<< pure <<< Right

instance bindExceptT :: Monad m => Bind (ExceptT m) where
  bind (ExceptT x) f =
    ExceptT do
      y <- x
      let
        g (ExceptT z) = z
      either (pure <<< Left <<< identity) (g <<< f) y

instance monadExceptT :: Monad m => Monad (ExceptT m)

instance monadThrowExceptT :: Monad m => MonadThrow Error (ExceptT m) where
  throwError = ExceptT <<< pure <<< Left

instance monadErrorExceptT :: Monad m => MonadError Error (ExceptT m) where
  catchError (ExceptT m) k = ExceptT (m >>= either (\a -> case k a of ExceptT b -> b) (pure <<< Right))

instance monadTransExceptT :: MonadTrans ExceptT where
  lift m =
    ExceptT do
      a <- m
      pure $ Right a

instance monadEffectExceptT :: MonadEffect m => MonadEffect (ExceptT m) where
  liftEffect = lift <<< liftEffect

instance monadAffExceptT :: MonadAff m => MonadAff (ExceptT m) where
  liftAff = lift <<< liftAff

-- | Error型に変換出来る型のクラス
class IsError e where
  convError :: e -> Error

instance errorIsError :: IsError Error where
  convError = identity

instance axIsError :: IsError AX.Error where
  convError = AXError

instance multipleIsError :: IsError F.MultipleErrors where
  convError = ForeignMultiError

error :: String -> Error
error = JSError <<< Exception.error

-- | 対応しているエラー型は自動で(convErrorを使って)変換
except :: forall e m a. Applicative m => IsError e => Either e a -> ExceptT m a
except = case _ of
  Left err -> ExceptT <<< pure <<< Left <<< convError $ err
  Right a -> ExceptT <<< pure <<< Right $ a

-- | runExceptT <<< except $ x == pure x ではないので注意したい(若干ダメな実装かも)
runExceptT :: forall m a. ExceptT m a -> m (Either Error a)
runExceptT (ExceptT x) = x

-- | Effect.Exception.ExceptTからの変換
convExceptT :: forall m e a. Functor m => IsError e => Except.ExceptT e m a -> ExceptT m a
convExceptT ex = case Except.withExceptT convError ex of
  Except.ExceptT x -> ExceptT x
