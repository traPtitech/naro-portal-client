module Kuragate.AppM where

import Prelude

import Affjax as Affjax
import Affjax.RequestBody as RequestBody
import Affjax.ResponseFormat as ResponseFormat
import Affjax.StatusCode (StatusCode(..))
import Control.Monad.Error.Class (class MonadThrow, throwError)
import Control.Monad.Except (runExcept)
import Data.Argonaut.Core (Json, stringify)
import Data.Argonaut.Parser (jsonParser)
import Data.Either (Either(..), either)
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff, Error, error)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Class.Console (log, logShow)
import Foreign.Generic (F, SumEncoding, defaultOptions, genericDecodeJSON, genericEncodeJSON)
import Halogen as H
import Halogen.Store.Monad (class MonadStore, StoreT, getStore, runStoreT, updateStore)
import Kuragate.Classes.LoginHandler (class LoginHandler)
import Kuragate.Classes.MessagesHandler (class MessagesHandler)
import Kuragate.Classes.NavigationHandler (class NavigationHandler)
import Kuragate.Classes.RegistrationHandler (class RegistrationHandler)
import Kuragate.Data.Message (Message(..), Messages(..))
import Kuragate.Data.Page (pageToHash)
import Kuragate.Data.Profile (Profile)
import Kuragate.Data.Requests (PostMessageReq(..))
import Kuragate.Data.ValidID (ValidID(..))
import Kuragate.Store (Action(..))
import Kuragate.Store as Store
import Routing.Hash (setHash)
import Safe.Coerce (coerce)

newtype AppM a
  = Cons (StoreT Store.Action Store.Store Aff a)

derive newtype instance Functor AppM
derive newtype instance Apply AppM
derive newtype instance Applicative AppM
derive newtype instance Bind AppM
derive newtype instance Monad AppM
derive newtype instance MonadEffect AppM
derive newtype instance MonadAff AppM

runApp :: forall a s q i o m. Monad m => s -> (s -> a -> s) → H.Component q i o AppM -> Aff (H.Component q i o m)
runApp initialStore reduce = runStoreT initialStore reduce <<< coerce

opts :: { fieldTransform :: String -> String
, sumEncoding :: SumEncoding
, unwrapSingleArguments :: Boolean
, unwrapSingleConstructors :: Boolean
}
opts = defaultOptions { unwrapSingleConstructors = true }

jsonParse :: forall m. MonadThrow Error m => String -> m Json
jsonParse str = either (throwError <<< error) pure $ jsonParser str

instance LoginHandler AppM where
  login req = liftAff $ do
    reqJson <- jsonParse $ genericEncodeJSON opts req
    res <- Affjax.post ResponseFormat.json "api/login" $ Just $ RequestBody.Json reqJson
    pure $ case res of
      Left _ -> false
      Right x | x.status /= (StatusCode 200) -> false
      _ -> true
  logout = liftAff $ do
    res <- Affjax.post ResponseFormat.json "api/logout" Nothing
    pure $ case res of
      Left _ -> false
      Right x | x.status /= (StatusCode 200) -> false
      _ -> true
  whoami = Cons $ (_.userProfile) <$> getStore
  updateProfile = Cons $ do
    res <- liftAff $ Affjax.get ResponseFormat.json "api/whoami"
    case res of
      Left _ -> pure false
      Right x | x.status /= (StatusCode 200) -> pure false
      Right x -> case runExcept (genericDecodeJSON opts $ stringify $ x.body :: F Profile) of
        Left _ -> do pure false
        Right prof -> do
          logShow prof
          updateStore $ SetUserProfile (Just prof)
          pure true

instance MessagesHandler AppM where
  getMessages = liftAff $ do
    res <- Affjax.get ResponseFormat.json "api/messages"
    case res of
      Left _ -> pure $ Messages []
      Right x | x.status /= (StatusCode 200) -> pure $ Messages []
      Right x -> do
        log $ stringify x.body
        either (\_ -> pure $ Messages []) pure $ runExcept (genericDecodeJSON opts $ stringify $ x.body :: F Messages)
  getMessage id = liftAff $ do
    res <- Affjax.get ResponseFormat.json $ "api/messages/" <> show id
    case res of
      Left _ -> pure Nothing
      Right x | x.status /= (StatusCode 200) -> pure Nothing
      Right x -> do
        log $ stringify x.body
        either (\_ -> pure Nothing) (pure <<< Just) $ runExcept (genericDecodeJSON opts $ stringify $ x.body :: F Message)
  postMessage text = liftAff $ do
    reqJson <- jsonParse $ genericEncodeJSON opts $ PostMessageReq { text:text }
    _ <- Affjax.post ResponseFormat.ignore "api/messages" $ Just $ RequestBody.Json reqJson
    pure unit
  deleteMessage id = pure unit
  favMessage id = liftAff $ do
    _ <- Affjax.put_ ("api/messages/" <> show id <> "/fav") $ Nothing
    pure unit
  unfavMessage id = liftAff $ do
    _ <- Affjax.delete_ $ "api/messages/" <> show id <> "/fav"
    pure unit

instance NavigationHandler AppM where
  navigate page = liftEffect $ setHash $ pageToHash page

instance RegistrationHandler AppM where
  register req = liftAff $ do
    reqJson <- jsonParse $ genericEncodeJSON opts req
    _ <- Affjax.post ResponseFormat.json "api/signup" (Just $ RequestBody.Json reqJson)
    pure unit
  unregister req = pure unit
  isValidID id = liftAff $ do
    res <- Affjax.get ResponseFormat.json $ "api/isvalidid/" <> id
    case res of
      Left _ -> pure $ ValidID $ false
      Right x | x.status /= (StatusCode 200) -> pure $ ValidID $ false
      Right x -> do
        log $ stringify x.body
        either (\_ -> pure $ ValidID $ false) pure $ runExcept (genericDecodeJSON opts $ stringify $ x.body :: F ValidID)

instance MonadThrow String AppM where
  throwError str = Cons $ liftEffect $ throwError $ error str