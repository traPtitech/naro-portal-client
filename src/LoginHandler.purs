module Src.LoginHandler where

import Prelude
import Affjax as AX
import Affjax.RequestBody as RequestBody
import Affjax.ResponseFormat as ResponseFormat
import Affjax.StatusCode (StatusCode(..))
import Control.Monad.Error.Class (throwError)
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
  result <- liftAff $ AX.post ResponseFormat.json "api/login" <<< Just <<< RequestBody.json $ reqJson --投げる
  response <- except result --帰ってきたのをエラー処理
  when (response.status == StatusCode 403) $ throwError WrongPasswordError --パスが違うとき
  when (response.status /= StatusCode 200) $ (throwError <<< error $ response.statusText) *> (liftEffect $ log "A") --その他のエラー
  profile <- whoami
  lift $ updateStore (Store.SetUserProfile (Just profile)) --Storeのユーザー情報を更新
  pure unit

whoami :: forall m. MonadAff m => ExceptT m Profile
whoami = do
  result <- liftAff $ AX.get ResponseFormat.json "api/whoami"
  response <- except $ result
  if response.status == StatusCode 200 then
    jsonToRecord $ response.body
  else if response.status == StatusCode 403 then -- StatusForbidden
    throwError NotLoginError
  else
    throwError <<< error $ response.statusText
