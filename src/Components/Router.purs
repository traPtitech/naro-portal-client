{-
ルーター
すべてのコンポーネントの親
Routesを元にログイン状態を考慮してルーティングをする
-}
module Kuragate.Components.Router where

import Prelude
import Control.Monad.Error.Class (class MonadThrow)
import Data.Maybe (Maybe(..), isNothing)
import Effect (Effect)
import Effect.Aff.Class (class MonadAff)
import Effect.Console (log)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.Query.Event (eventListener)
import Halogen.Store.Monad (class MonadStore)
import Halogen.Subscription as HS
import Kuragate.Classes.LoginHandler (class LoginHandler, updateProfile, whoami)
import Kuragate.Classes.MessagesHandler (class MessagesHandler)
import Kuragate.Classes.NavigationHandler (class NavigationHandler, navigate)
import Kuragate.Classes.RegistrationHandler (class RegistrationHandler)
import Kuragate.Components.Home as Home
import Kuragate.Components.Login as Login
import Kuragate.Components.Register as Register
import Kuragate.Components.Settings as Settings
import Kuragate.Data.Page (Page(..), hashToPage, loginRequired, notLoginDefaultPage)
import Kuragate.Store as Store
import Routing.Hash (getHash)
import Web.HTML (window)
import Web.HTML.Event.HashChangeEvent (fromEvent, newURL)
import Web.HTML.Event.HashChangeEvent.EventTypes (hashchange)
import Web.HTML.Window (toEventTarget)

type Input
  = Unit

type Slots
  = ( login :: Login.Slot Unit, home :: Home.Slot Unit, settings :: Settings.Slot Unit, register :: Register.Slot Unit )

type State
  = { currentPage :: Page }

data Action
  = Initialize
  | HashChange String

component ::
  forall query output m.
  MonadAff m =>
  MessagesHandler m =>
  NavigationHandler m =>
  LoginHandler m =>
  MonadThrow String m =>
  RegistrationHandler m =>
  MonadStore Store.Action Store.Store m =>
  H.Component query Input output m
component =
  H.mkComponent
    { initialState: \_ -> initialState
    , render
    , eval:
        H.mkEval
          $ H.defaultEval
              { handleAction = handleAction
              , initialize = Just Initialize
              }
    }

initialState :: State
initialState = { currentPage: NotFoundPage }

render ::
  forall m.
  MonadStore Store.Action Store.Store m =>
  MonadAff m =>
  MessagesHandler m =>
  NavigationHandler m =>
  LoginHandler m =>
  MonadThrow String m =>
  RegistrationHandler m =>
  State -> H.ComponentHTML Action Slots m
render state = do
  HH.div [ HP.class_ $ H.ClassName "app" ]
    [ navigationBar state
    , case state.currentPage of
        HomePage -> HH.slot_ Home._home unit Home.component unit
        LoginPage -> HH.slot_ Login._login unit Login.component unit
        SettingsPage -> HH.slot_ Settings._settings unit Settings.component {}
        NotFoundPage -> HH.text "Page Not Found"
        RegisterPage -> HH.slot_ Register._register unit Register.component {}
        ProfilePage _ -> HH.text "Page Not Found"
    ]

-- | ナビゲーションバーを作成
navigationBar :: forall w i. State -> HH.HTML w i
navigationBar state = do
  HH.div [ HP.class_ $ H.ClassName "navigation_bar" ]
    [ navigationLink "#home" "Home" HomePage
    , HH.text " | "
    , navigationLink "#settings" "Settings" SettingsPage
    ]
  where
  navigationLink url text page =
    HH.a
      [ HP.href url, HP.class_ $ H.ClassName if state.currentPage == page then "navigation_bar_selected" else "" ]
      [ HH.text text ]

handleAction ::
  forall output m.
  MonadAff m =>
  MonadStore Store.Action Store.Store m =>
  LoginHandler m =>
  NavigationHandler m =>
  Action -> H.HalogenM State Action Slots output m Unit
handleAction = case _ of
  Initialize -> do --ユーザーが最初に着地したときの処理
    _ <- updateProfile
    emitter <- H.liftEffect hashChangeEmitter
    _ <- H.subscribe emitter
    hashChangeHandler
  HashChange _ -> do
    hashChangeHandler

hashChangeHandler ::
  forall output m.
  MonadAff m =>
  LoginHandler m =>
  MonadStore Store.Action Store.Store m =>
  NavigationHandler m =>
  H.HalogenM State Action Slots output m Unit
hashChangeHandler = do
  hash <- H.liftEffect getHash
  H.liftEffect (log hash)
  prof <- whoami
  let
    page = hashToPage $ hash
  if loginRequired page && (isNothing prof) then
    navigate notLoginDefaultPage
  else
    H.modify_ _ { currentPage = page }

-- | ハッシュ以降のURLの変化を検知するEmitter
hashChangeEmitter :: Effect (HS.Emitter Action)
hashChangeEmitter = do
  targetWindow <- toEventTarget <$> window
  pure
    $ eventListener
        hashchange
        targetWindow
        (\ev -> HashChange <<< newURL <$> fromEvent ev)
