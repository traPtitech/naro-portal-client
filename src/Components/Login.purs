module Src.Components.Login where

import Prelude
import Affjax as AX
import Affjax.ResponseFormat as ResponseFormat
import Affjax.StatusCode (StatusCode(..))
import Data.Either (Either(..))
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Effect.Aff.Class (class MonadAff)
import Effect.Console (log)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Store.Connect (connect)
import Halogen.Store.Monad (class MonadStore)
import Halogen.Store.Select (selectAll)
import Src.Store as Store
import Type.Proxy (Proxy(..))
import Web.Event.Event (preventDefault)
import Web.Event.Internal.Types (Event)

type Slot id
  = forall q. H.Slot q Void id

_login = Proxy :: Proxy "login"

type State
  = { id :: String
    , password :: String
    , isFail :: Boolean
    }

data Action
  = SetID String
  | SetPassWord String
  | Login Event

newtype LoginReqestBody
  = LoginReqestBody { id :: String, password :: String }

derive instance genericLoginReqestBody :: Generic LoginReqestBody _

component :: forall query input output m. MonadStore Store.Action Store.Store m => MonadAff m => H.Component query input output m
component =
  connect selectAll
    $ H.mkComponent
        { initialState
        , render
        , eval: H.mkEval H.defaultEval { handleAction = handleAction }
        }

initialState :: forall input. input -> State
initialState _ = { id: "", password: "", isFail: false }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div_
    [ HH.form [ HP.class_ $ H.ClassName "form", HE.onSubmit \ev -> Login ev ]
        $ [ HH.ul_
              [ HH.li_
                  [ HH.label_ [ HH.text "User ID" ]
                  , HH.input
                      [ HP.value state.id
                      , HE.onValueInput SetID
                      ]
                  ]
              , HH.li_
                  [ HH.label_ [ HH.text "PassWord" ]
                  , HH.input
                      [ HP.value state.password
                      , HP.type_ HP.InputPassword
                      , HE.onValueInput SetPassWord
                      ]
                  ]
              , HH.li_ [ HH.button [ HP.type_ HP.ButtonSubmit, HP.id "submit_button" ] [ HH.text "Login" ] ]
              , HH.li [ HP.class_ $ H.ClassName "error_massage" ] [ HH.text $ if state.isFail then "ログインに失敗しました" else "" ]
              ]
          ]
    , HH.div_ [ HH.a [ HP.href "#signup", HP.class_ $ H.ClassName "small" ] [ HH.text "アカウントを作成" ] ]
    ]

handleAction :: forall output m. MonadAff m => Action -> H.HalogenM State Action () output m Unit
handleAction = case _ of
  SetID id -> H.modify_ _ { id = id }
  SetPassWord password -> H.modify_ _ { password = password }
  Login ev -> pure unit {-do
    H.liftEffect $ preventDefault ev
    state <- H.get
    result <-
      H.liftAff
        $ AX.post ResponseFormat.ignore "api/login"
        $ makeJsonRequest
        $ LoginReqestBody { id: state.id, password: state.password }
    case result of
      Left _ -> H.modify_ _ { isFail = true }
      Right res
        | res.status == StatusCode 200 -> H.liftEffect (log "A") *> (H.liftEffect $ setHash "home") -- Loginに成功したらhomeに遷移
        | otherwise -> H.modify_ _ { isFail = true }-}
