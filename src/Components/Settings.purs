module Kuragate.Components.Settings where

import Prelude
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.Store.Monad (class MonadStore)
import Kuragate.Classes.LoginHandler (class LoginHandler, logout)
import Kuragate.Classes.NavigationHandler (class NavigationHandler, navigate)
import Kuragate.Data.Page (Page(..))
import Kuragate.Store as Store
import Type.Proxy (Proxy(..))

type Slot id
  = forall q. H.Slot q Void id

_settings = Proxy :: Proxy "settings"

type State
  = {}

data Action
  = Logout

component ::
  forall query input output m.
  MonadAff m =>
  LoginHandler m =>
  NavigationHandler m =>
  MonadStore Store.Action Store.Store m => H.Component query input output m
component =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval H.defaultEval { handleAction = handleAction }
    }

initialState :: forall input. input -> State
initialState _ = {}

render :: forall m. State -> H.ComponentHTML Action () m
render _ =
  HH.div_
    [ HH.button [ HE.onClick \_ -> Logout ] [ HH.text "Logout" ] ]

handleAction ::
  forall output m.
  MonadAff m =>
  MonadStore Store.Action Store.Store m =>
  LoginHandler m =>
  NavigationHandler m =>
  Action -> H.HalogenM State Action () output m Unit
handleAction = case _ of
  Logout -> do
    logout
    navigate LoginPage
