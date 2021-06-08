{-
ルーター
すべてのコンポーネントの親
Routesを元にログイン状態を考慮してルーティングをする
-}
module Src.Router where

import Prelude
import Data.Maybe (Maybe(..), isNothing)
import Effect.Aff.Class (class MonadAff)
import Halogen (get)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.Store.Connect (Connected, connect)
import Halogen.Store.Monad (class MonadStore, updateStore)
import Halogen.Store.Select (Selector, selectEq)
import Routing.Hash (setHash)
import Src.Components.Home as Home
import Src.Components.Login as Login
import Src.Components.Settings as Settings
import Src.Components.Signup as Signup
import Src.Profile (Profile)
import Src.Routes as Routes
import Src.Store as Store

type Input
  = Unit

type Slots
  = ( login :: Login.Slot Unit, home :: Home.Slot Unit, settings :: Settings.Slot Unit, signup :: Signup.Slot Unit )

type State
  = { currentPage :: Routes.Page, userProfile :: Maybe (Profile) }

-- | Storeと同期するStateの選択
type DerivingState
  = { userProfile :: Maybe Profile, currentPage :: Routes.Page }

-- | StoreからのInputでStoreとStateを同期する関数
deriveState :: Connected DerivingState Input -> State
deriveState { context, input } = { currentPage: context.currentPage, userProfile: context.userProfile }

selectDerivingState :: Selector Store.Store DerivingState
selectDerivingState = selectEq \store -> { userProfile: store.userProfile, currentPage: store.currentPage }

data Action
  = Receive (Connected DerivingState Input)

component ::
  forall query output m.
  MonadAff m =>
  MonadStore Store.Action Store.Store m =>
  H.Component query Input output m
component =
  connect selectDerivingState
    $ H.mkComponent
        { initialState: deriveState
        , render
        , eval:
            H.mkEval
              $ H.defaultEval
                  { handleAction = handleAction
                  , receive = Just <<< Receive
                  }
        }

initialState :: forall input. input -> State
initialState _ = { currentPage: Routes.NotFoundPage, userProfile: Nothing }

render :: forall m. MonadStore Store.Action Store.Store m => MonadAff m => State -> H.ComponentHTML Action Slots m
render state = do
  HH.div [ HP.class_ $ H.ClassName "app" ]
    $ case state.currentPage of
        Routes.HomePage -> [ HH.slot_ Home._home unit Home.component {} ]
        Routes.LoginPage -> [ HH.slot_ Login._login unit Login.component {} ]
        Routes.SettingsPage -> [ HH.slot_ Settings._settings unit Settings.component {} ]
        Routes.NotFoundPage -> [ HH.text "Page Not Found" ]
        Routes.SignupPage -> [ HH.slot_ Signup._signup unit Signup.component {} ]

handleAction :: forall output m. MonadAff m => MonadStore Store.Action Store.Store m => Action -> H.HalogenM State Action Slots output m Unit
handleAction = case _ of
  Receive input -> do
    H.put $ deriveState input --Storeの同期
    state <- get
    if Routes.loginRequired state.currentPage && (isNothing $ state.userProfile) then
      updateStore <<< Store.Navigate $ Routes.notLoginDefaultPage --Loginしていないならページを置き換え
    else do
      let
        targetPage = state.currentPage
      H.liftEffect $ setHash <<< Routes.pageToHash $ targetPage --Hashの書き換え
