{-
ユーザーのプロフィール情報に関する諸々(APIなど)
-}
module Src.Profile where

import Prelude
import Affjax as AX
import Affjax.ResponseFormat as ResponseFormat
import Affjax.StatusCode (StatusCode(..))
import Data.Generic.Rep (class Generic)
import Effect.Aff (Aff, throwError)
import Effect.Aff.Class (liftAff)
import Src.Wrapper.Exception (Error(..), ExceptT, except)
import Src.Wrapper.Generic (jsonToRecord)

data Profile
  = Profile
    { id :: String
    , name :: String
    }

derive instance genericProfile :: Generic Profile _

derive instance eqProfile :: Eq Profile

whoami :: ExceptT Aff Profile
whoami = do
  result <- liftAff $ AX.get ResponseFormat.json "api/whoami"
  response <- except $ result
  if response.status == StatusCode 200 then
    jsonToRecord $ response.body
  else
    throwError NotLoginError
