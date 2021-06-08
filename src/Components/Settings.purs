module Src.Components.Settings where

import Prelude
import Affjax as AX
import Affjax.ResponseFormat as ResponseFormat
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Type.Proxy (Proxy(..))

type Slot id
  = forall q. H.Slot q Void id

_settings = Proxy :: Proxy "settings"

type State
  = {}

data Action
  = Logout

component :: forall query input output m. MonadAff m => H.Component query input output m
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

handleAction :: forall output m. MonadAff m => Action -> H.HalogenM State Action () output m Unit
handleAction = case _ of
  Logout -> do
    _ <- H.liftAff $ AX.get ResponseFormat.ignore "api/logout"
    pure unit
