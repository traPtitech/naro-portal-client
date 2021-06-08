module Src.LoginHandler where

import Prelude
import Affjax as AX
import Affjax.RequestBody as RequestBody
import Affjax.ResponseFormat as ResponseFormat
import Affjax.StatusCode (StatusCode(..))
import Control.Monad.Error.Class (catchError, throwError)
import Control.Monad.Trans.Class (lift)
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Halogen.Store.Monad (class MonadStore, updateStore)
import Src.Profile (Profile)
import Src.Store as Store
import Src.Wrapper.Exception (Error(..), ExceptT, except, error)
import Src.Wrapper.Generic (jsonToRecord, recordToJson)

data LoginRequestBody
  = LoginRequestBody
    { id :: String
    , password :: String
    }

derive instance genericLoginReqestBody :: Generic LoginRequestBody _

-- | ログインをする関数
login :: forall m. MonadStore Store.Action Store.Store m => MonadAff m => LoginRequestBody -> ExceptT m Unit
login req = do
  reqJson <- recordToJson req --RecordをJSONに変換
  result <- liftAff $ AX.post ResponseFormat.ignore "api/login" <<< Just <<< RequestBody.json $ reqJson --投げる
  response <- except result --帰ってきたのをエラー処理
  when (response.status == StatusCode 403) $ throwError WrongPasswordError --パスワードが違うとき
  when (response.status /= StatusCode 200) $ (throwError <<< error $ response.statusText) --その他のエラー
  profile <- whoami --自分のユーザー情報を取得
  lift $ updateStore (Store.SetUserProfile (Just profile)) --Storeのユーザー情報を更新

-- | 自分のユーザー情報を取得する関数
whoami :: forall m. MonadAff m => ExceptT m Profile
whoami = do
  result <- liftAff $ AX.get ResponseFormat.json "api/whoami"
  response <- except $ result
  when (response.status == StatusCode 403) $ throwError NotLoginError -- StatusForbidden
  when (response.status /= StatusCode 200) $ throwError <<< error $ response.statusText
  jsonToRecord $ response.body

updateUserProfile :: forall m. MonadStore Store.Action Store.Store m => MonadAff m => ExceptT m Unit
updateUserProfile = do
  prof <- catchError (Just <$> whoami) (\err -> (liftEffect <<< log <<< show $ err) *> pure Nothing)
  lift $ updateStore (Store.SetUserProfile prof) --Storeのユーザー情報を更新
