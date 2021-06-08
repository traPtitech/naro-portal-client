{-
グローバルなStateを管理
主にユーザー情報(ログインしているか、していないかなど)と
-}
module Src.Store where

import Data.Maybe (Maybe(..))
import Halogen.Store.Select (Selector, selectEq)
import Src.Profile (Profile)

type Store
  = { userProfile :: Maybe Profile }

selectUserProfile :: Selector Store (Maybe Profile)
selectUserProfile = selectEq \store -> store.userProfile

initialStore :: Store
initialStore = { userProfile: Nothing }

data Action
  = SetUserProfile (Maybe Profile) --ユーザー情報の変更

reduce :: Store -> Action -> Store
reduce store = case _ of
  SetUserProfile prof -> store { userProfile = prof }
