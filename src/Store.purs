{-
グローバルなStateを管理
主にユーザー情報(ログインしているか、していないかなど)と
-}
module Kuragate.Store where

import Data.Maybe (Maybe(..))
import Kuragate.Data.Profile (Profile)

type Store
  = { userProfile :: Maybe Profile }

initialStore :: Store
initialStore = { userProfile: Nothing }

data Action
  = SetUserProfile (Maybe Profile) --ユーザー情報の変更

reduce :: Store -> Action -> Store
reduce store = case _ of
  SetUserProfile prof -> store { userProfile = prof }
