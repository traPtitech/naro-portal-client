{-
グローバルなStateを管理
主にユーザー情報(ログインしているか、していないかなど)と
現在開いているページの管理

Storeのページの変更をRouterが感知してページ遷移を起こす仕組み
-}
module Src.Store where

import Data.Maybe (Maybe(..))
import Halogen.Store.Select (Selector, selectEq)
import Src.Profile (Profile)
import Src.Routes (Page(..))

type Store
  = { userProfile :: Maybe Profile, currentPage :: Page }

selectUserProfile :: Selector Store (Maybe Profile)
selectUserProfile = selectEq \store -> store.userProfile

selectCurrentPage :: Selector Store Page
selectCurrentPage = selectEq \store -> store.currentPage

initialStore :: Store
initialStore = { userProfile: Nothing, currentPage: NotFoundPage }

data Action
  = SetUserProfile (Maybe Profile) --ユーザー情報の変更
  | Navigate Page --指定したページをセットする

reduce :: Store -> Action -> Store
reduce store = case _ of
  SetUserProfile prof -> store { userProfile = prof }
  Navigate page -> store { currentPage = page }
