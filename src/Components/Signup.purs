module Src.Components.Signup where

import Prelude
import Affjax as AX
import Affjax.RequestBody as RequestBody
import Affjax.ResponseFormat as ResponseFormat
import Affjax.StatusCode (StatusCode(..))
import Control.Monad.Error.Class (throwError)
import Data.Argonaut.Core (fromString, toBoolean)
import Data.Either (Either(..), either)
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Effect.Aff.Class (class MonadAff)
import Effect.Console (log)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Routing.Hash (setHash)
import Src.Wrapper.Exception (ExceptT, error, except, runExceptT)
import Src.Wrapper.Generic (recordToJson)
import Type.Proxy (Proxy(..))
import Web.Event.Event (Event, preventDefault)

type Slot id
  = forall q. H.Slot q Void id

_signup = Proxy :: Proxy "signup"

type State
  = { id :: String
    , name :: String
    , password :: String
    , validID :: Boolean
    }

data Action
  = SetID String
  | SetName String
  | SetPassWord String
  | Signup Event
  | CheckValidID

newtype SignupRequestBody
  = SignupRequestBody { id :: String, name :: String, password :: String }

derive instance genericSignupRequestBody :: Generic SignupRequestBody _

component :: forall query input output m. MonadAff m => H.Component query input output m
component =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval H.defaultEval { handleAction = handleAction }
    }

initialState :: forall input. input -> State
initialState _ = { id: "", name: "", password: "", validID: false }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div_
    [ HH.form [ HP.class_ $ H.ClassName "form", HE.onSubmit \ev -> Signup ev ]
        $ [ HH.ul_
              [ HH.li_ [ HH.text "IDとPasswordは半角英数のみ有効です。" ]
              , HH.li_ [ HH.text "括弧で指定された文字数以内で入力してください。" ]
              , HH.li_
                  [ HH.label_ [ HH.text "User ID(20)" ]
                  , HH.input
                      [ HP.value state.id
                      , HP.pattern "[!-~]{1,20}"
                      , HE.onValueInput SetID
                      , HE.onBlur \_ -> CheckValidID
                      , HP.required true
                      ]
                  ]
              , HH.li_
                  [ HH.label_ [ HH.text "PassWord(20)" ]
                  , HH.input
                      [ HP.value state.password
                      , HP.pattern "[!-~]{1,20}"
                      , HP.type_ HP.InputPassword
                      , HE.onValueInput SetPassWord
                      , HP.required true
                      ]
                  ]
              , HH.li_ [ HH.text "- Profile -" ]
              , HH.li_
                  [ HH.label_ [ HH.text "Name(30)" ]
                  , HH.input
                      [ HP.value state.name
                      , HP.pattern "{1,30}"
                      , HE.onValueInput SetName
                      , HP.required true
                      ]
                  ]
              , HH.li_ [ HH.button [ HP.type_ HP.ButtonSubmit, HP.disabled $ not state.validID, HP.id "submit_button" ] [ HH.text "Signup" ] ]
              , HH.li_ [ HH.text if state.validID then "" else "ユーザー名が重複しているか、空です。" ]
              ]
          ]
    , HH.div_ [ HH.a [ HP.href "#login", HP.class_ $ H.ClassName "small" ] [ HH.text "ログイン画面へ" ] ]
    ]

handleAction :: forall output m. MonadAff m => Action -> H.HalogenM State Action () output m Unit
handleAction = case _ of
  SetID id -> H.modify_ _ { id = id }
  SetPassWord password -> H.modify_ _ { password = password }
  SetName name -> H.modify_ _ { name = name }
  Signup ev -> do
    H.liftEffect $ preventDefault ev
    state <- H.get
    result <- runExceptT <<< signUpAPI $ SignupRequestBody { id: state.id, name: state.name, password: state.password }
    either (H.liftEffect <<< log <<< show) (\_ -> H.liftEffect $ setHash "#login") result
  CheckValidID -> do
    state <- H.get
    checkValid "api/isvalidid" state.id $ \x -> H.modify_ _ { validID = x }

signUpAPI :: forall m. MonadAff m => SignupRequestBody -> ExceptT m Unit
signUpAPI req = do
  reqJson <- recordToJson req
  result <- H.liftAff <<< AX.post ResponseFormat.ignore "api/signup" <<< Just <<< RequestBody.json $ reqJson
  response <- except result
  when (response.status /= StatusCode 200) $ throwError <<< error $ response.statusText

checkValid ::
  forall output m.
  MonadAff m =>
  String ->
  String ->
  (Boolean -> H.HalogenM State Action () output m Unit) -> H.HalogenM State Action () output m Unit
checkValid reqURL str target = do
  result <-
    H.liftAff
      $ AX.post ResponseFormat.json reqURL
      $ Just
      $ RequestBody.json
      $ fromString
      $ str
  case result of
    Left _ -> target false
    Right res -> case toBoolean res.body of
      Nothing -> target false
      Just x -> target x
