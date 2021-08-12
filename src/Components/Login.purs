module Kuragate.Components.Login where

import Prelude
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Store.Monad (class MonadStore)
import Kuragate.Classes.LoginHandler (class LoginHandler, login)
import Kuragate.Classes.NavigationHandler (class NavigationHandler, navigate)
import Kuragate.Data.Page (Page(..))
import Kuragate.Store as Store
import Type.Proxy (Proxy(..))
import Web.Event.Event (preventDefault)
import Web.Event.Internal.Types (Event)

type Slot id
  = forall q. H.Slot q Void id

_login = Proxy :: Proxy "login"

type State
  = { id :: String
    , password :: String
    , passState :: PassState
    }

data Action
  = SetID String
  | SetPassWord String
  | Login Event

data PassState
  = NormalState
  | WrongPassword
  | InternalError

component ::
  forall query input output m.
  MonadStore Store.Action Store.Store m =>
  LoginHandler m =>
  NavigationHandler m =>
  MonadAff m =>
  H.Component query input output m
component =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval H.defaultEval { handleAction = handleAction }
    }

initialState :: forall input. input -> State
initialState _ = { id: "", password: "", passState: NormalState }

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
              , HH.li [ HP.class_ $ H.ClassName "error_massage" ]
                  [ HH.text
                      $ case state.passState of
                          NormalState -> ""
                          WrongPassword -> "パスワードが違います"
                          InternalError -> "内部エラーが発生しました"
                  ]
              ]
          ]
    , HH.div_ [ HH.a [ HP.href "#signup", HP.class_ $ H.ClassName "small" ] [ HH.text "アカウントを作成" ] ]
    ]

handleAction ::
  forall output m.
  MonadAff m =>
  MonadStore Store.Action Store.Store m =>
  LoginHandler m =>
  NavigationHandler m =>
  Action -> H.HalogenM State Action () output m Unit
handleAction = case _ of
  SetID id -> H.modify_ _ { id = id }
  SetPassWord password -> H.modify_ _ { password = password }
  Login ev -> do
    H.liftEffect $ preventDefault ev
    state <- H.get
    login { id: state.id, password: state.password }
    navigate HomePage
