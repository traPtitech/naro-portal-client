{-
ルーター
すべてのコンポーネントの親
Routesを元にログイン状態を考慮してルーティングをする
-}
module Src.Router where

import Prelude
import Data.Maybe (Maybe(..), isNothing)
import Effect (Effect)
import Effect.Aff.Class (class MonadAff)
import Effect.Console (log)
import Halogen (get)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.Query.Event (eventListener)
import Halogen.Store.Connect (Connected, connect)
import Halogen.Store.Monad (class MonadStore)
import Halogen.Store.Select (Selector, selectEq)
import Halogen.Subscription as HS
import Routing.Hash (getHash, setHash)
import Src.Components.Home as Home
import Src.Components.Login as Login
import Src.Components.Settings as Settings
import Src.Components.Signup as Signup
import Src.Profile (Profile)
import Src.Routes as Routes
import Src.Store as Store
import Web.HTML (window)
import Web.HTML.Event.HashChangeEvent (fromEvent, newURL)
import Web.HTML.Event.HashChangeEvent.EventTypes (hashchange)
import Web.HTML.Window (toEventTarget)

type Input
  = Unit

type Slots
  = ( login :: Login.Slot Unit, home :: Home.Slot Unit, settings :: Settings.Slot Unit, signup :: Signup.Slot Unit )

type State
  = { currentPage :: Routes.Page, userProfile :: Maybe (Profile) }

-- | Storeと同期するStateの選択
type DerivingState
  = Maybe Profile

-- | StoreからのInputでStoreとStateを同期する関数
deriveState :: Connected DerivingState Input -> State -> State
deriveState conInput = _ { userProfile = conInput.context }

selectDerivingState :: Selector Store.Store DerivingState
selectDerivingState = selectEq \store -> store.userProfile

data Action
  = Receive (Connected DerivingState Input)
  | Initialize
  | HashChange String

component ::
  forall query output m.
  MonadAff m =>
  MonadStore Store.Action Store.Store m =>
  H.Component query Input output m
component =
  connect selectDerivingState
    $ H.mkComponent
        { initialState: (\x -> deriveState x initialState)
        , render
        , eval:
            H.mkEval
              $ H.defaultEval
                  { handleAction = handleAction
                  , receive = Just <<< Receive
                  , initialize = Just Initialize
                  }
        }

initialState :: State
initialState = { currentPage: Routes.NotFoundPage, userProfile: Nothing }

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
  Initialize -> do --ユーザーが最初に着地したときの処理
    emitter <- H.liftEffect hashChangeEmitter
    _ <- H.subscribe emitter
    hashChangeHandler
  Receive input -> do
    H.modify_ $ deriveState input --Storeの同期
  HashChange _ -> do
    hashChangeHandler

hashChangeHandler :: forall output m. MonadAff m => MonadStore Store.Action Store.Store m => H.HalogenM State Action Slots output m Unit
hashChangeHandler = do
  hash <- H.liftEffect getHash
  H.liftEffect (log hash)
  state <- get
  let
    page = Routes.hashToPage $ hash
  if Routes.loginRequired page && (isNothing $ state.userProfile) then
    H.liftEffect <<< setHash <<< Routes.pageToHash $ Routes.notLoginDefaultPage
  else
    H.modify_ _ { currentPage = page }

-- | ハッシュ以降のURLの変化を検知するEmitter
-- | ブラウザの戻るボタンを押した時専用
hashChangeEmitter :: Effect (HS.Emitter Action)
hashChangeEmitter = do
  targetWindow <- toEventTarget <$> window
  pure
    $ eventListener
        hashchange
        targetWindow
        (\ev -> HashChange <<< newURL <$> fromEvent ev)
