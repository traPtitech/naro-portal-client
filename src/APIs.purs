{-
サーバーとの通信
-}
module Src.APIs where

import Prelude
import Affjax as AX
import Affjax.RequestBody as RequestBody
import Affjax.ResponseFormat as ResponseFormat
import Affjax.StatusCode (StatusCode(..))
import Control.Monad.Error.Class (catchError, throwError)
import Control.Monad.Trans.Class (lift)
import Data.Argonaut.Core (stringify)
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Halogen.Store.Monad (class MonadStore, updateStore)
import Src.Profile (Profile)
import Src.Store as Store
import Src.Wrapper.Exception (Error(..), ExceptT, error, except)
import Src.Wrapper.Generic (jsonToRecord, recordToJson)

newtype LoginRequestBody
  = LoginRequestBody
  { id :: String
  , password :: String
  }

derive instance genericLoginReqestBody :: Generic LoginRequestBody _

-- | ログイン
login :: forall m. MonadStore Store.Action Store.Store m => MonadAff m => LoginRequestBody -> ExceptT m Unit
login req = do
  reqJson <- recordToJson req
  result <- liftAff <<< AX.post ResponseFormat.json "api/login" <<< Just <<< RequestBody.json $ reqJson
  response <- except result
  when (response.status == StatusCode 403) $ throwError WrongPasswordError
  when (response.status /= StatusCode 200) $ throwError <<< error <<< stringify $ response.body
  updateUserProfile

-- | ログアウト
logout :: forall m. MonadStore Store.Action Store.Store m => MonadAff m => ExceptT m Unit
logout = do
  result <- liftAff <<< AX.get ResponseFormat.json $ "api/logout"
  response <- except result
  when (response.status == StatusCode 403) $ throwError NotLoginError
  when (response.status /= StatusCode 200) $ throwError <<< error <<< stringify $ response.body
  updateUserProfile

-- | 自分のユーザー情報を取得する関数
whoami :: forall m. MonadAff m => ExceptT m Profile
whoami = do
  result <- liftAff <<< AX.get ResponseFormat.json $ "api/whoami"
  response <- except result
  when (response.status == StatusCode 403) $ throwError NotLoginError
  when (response.status /= StatusCode 200) $ throwError <<< error <<< stringify $ response.body
  jsonToRecord response.body

-- | ユーザー情報を更新
updateUserProfile :: forall m. MonadStore Store.Action Store.Store m => MonadAff m => ExceptT m Unit
updateUserProfile = do
  prof <-
    catchError (Just <$> whoami) case _ of
      NotLoginError -> pure Nothing
      err -> do
        liftEffect <<< log <<< show $ err
        pure Nothing
  lift $ updateStore (Store.SetUserProfile prof) --Storeのユーザー情報を更新

newtype SignupRequestBody
  = SignupRequestBody
  { id :: String
  , name :: String
  , password :: String
  }

derive instance genericSignupRequestBody :: Generic SignupRequestBody _

-- | サインアップ
signup :: forall m. MonadStore Store.Action Store.Store m => MonadAff m => SignupRequestBody -> ExceptT m Unit
signup req = do
  reqJson <- recordToJson req
  result <- liftAff $ AX.post ResponseFormat.json "api/signup" <<< Just <<< RequestBody.json $ reqJson
  response <- except result
  when (response.status /= StatusCode 201) $ throwError <<< error <<< stringify $ response.body

type Message
  = { id :: Int
    , user_id :: String
    , text :: String
    , post_time :: String
    , fav_users :: Array String
    }

newtype MessageBody
  = MessageBody Message

derive instance genericMessageBody :: Generic MessageBody _

newtype MessagesBody
  = MessagesBody (Array Message)

derive instance genericMessagesBody :: Generic MessagesBody _

-- | すべてのメッセージを取得
messages :: forall m. MonadAff m => ExceptT m MessagesBody
messages = do
  result <- liftAff <<< AX.get ResponseFormat.json $ "api/messages"
  response <- except result
  when (response.status == StatusCode 403) $ throwError NotLoginError
  when (response.status /= StatusCode 200) $ throwError <<< error <<< stringify $ response.body
  jsonToRecord response.body

-- | 一つのメッセージを取得
message :: forall m. MonadAff m => Int -> ExceptT m MessageBody
message id = do
  result <- liftAff <<< AX.get ResponseFormat.json $ "api/messages/" <> show id
  response <- except result
  when (response.status == StatusCode 403) $ throwError NotLoginError
  when (response.status /= StatusCode 200) $ throwError <<< error <<< stringify $ response.body
  jsonToRecord response.body

fav :: forall m. MonadAff m => Int -> ExceptT m Unit
fav id = do
  result <- liftAff <<< AX.put ResponseFormat.json ("api/messages/" <> show id <> "/fav") $ Nothing
  response <- except result
  when (response.status == StatusCode 403) $ throwError NotLoginError
  when (response.status /= StatusCode 200) $ throwError <<< error <<< stringify $ response.body

unFav :: forall m. MonadAff m => Int -> ExceptT m Unit
unFav id = do
  result <- liftAff <<< AX.delete ResponseFormat.json $ "api/messages/" <> show id <> "/fav"
  response <- except result
  when (response.status == StatusCode 403) $ throwError NotLoginError
  when (response.status /= StatusCode 200) $ throwError <<< error <<< stringify $ response.body

newtype PostMessageRequestBody
  = PostMessageRequestBody { text :: String }

derive instance genericPostRequestBody :: Generic PostMessageRequestBody _

postMessage :: forall m. MonadAff m => PostMessageRequestBody -> ExceptT m Unit
postMessage req = do
  reqJson <- recordToJson req
  result <- liftAff <<< AX.post ResponseFormat.json "api/messages" <<< Just <<< RequestBody.json $ reqJson
  response <- except result
  when (response.status == StatusCode 403) $ throwError NotLoginError
  when (response.status /= StatusCode 200) $ throwError <<< error <<< stringify $ response.body
