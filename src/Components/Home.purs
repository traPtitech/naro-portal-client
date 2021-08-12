module Kuragate.Components.Home where

import Prelude
import Control.Monad.Error.Class (class MonadThrow, throwError)
import Data.Array (elem)
import Data.Maybe (Maybe(..), fromMaybe)
import Effect.Aff.Class (class MonadAff)
import Effect.Console (logShow)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Store.Monad (class MonadStore)
import Kuragate.Classes.LoginHandler (class LoginHandler, whoami)
import Kuragate.Classes.MessagesHandler (class MessagesHandler, favMessage, getMessage, getMessages, postMessage, unfavMessage)
import Kuragate.Data.Message (Message(..), MessageRecord, Messages(..))
import Kuragate.Data.Profile (Profile(..))
import Kuragate.Store as Store
import Type.Proxy (Proxy(..))

type Slot id
  = forall q. H.Slot q Void id

_home = Proxy :: Proxy "home"

type State
  = { messages :: Messages
    , text :: String
    }

data Action
  = UpdateTimeLine
  | Initialize
  | SetText String
  | Post String
  | Fav Int

type Input
  = Unit

component ::
  forall query output m.
  MonadAff m =>
  MessagesHandler m =>
  LoginHandler m =>
  MonadThrow String m =>
  MonadStore Store.Action Store.Store m =>
  H.Component query Input output m
component =
  H.mkComponent
    { initialState: \_ -> initialState
    , render
    , eval: H.mkEval H.defaultEval { handleAction = handleAction, initialize = Just Initialize }
    }

initialState :: State
initialState = { messages: Messages [], text: "" }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div_
    [ HH.div_
        [ HH.input
            [ HP.value state.text
            , HE.onValueInput SetText
            ]
        , HH.button [ HE.onClick (\_ -> Post state.text) ] [ HH.text "Post" ]
        ]
    , HH.div_
        $ map postBlock messages
    ]
  where
  (Messages messages) = state.messages

postBlock :: forall w. MessageRecord -> HH.HTML w Action
postBlock message = do
  HH.div [ HP.class_ $ H.ClassName "post" ]
    $ [ HH.div_ [ HH.text $ "@" <> message.user_id ]
      , HH.div_ [ HH.text $ message.text ]
      , HH.div_
          $ [ HH.button [ HE.onClick \_ -> Fav message.id ] [ HH.text "❤" ] ]
          <> map (\x -> HH.text $ " " <> x <> " ") message.fav_users
      ]

handleAction ::
  forall output m.
  MonadAff m =>
  MessagesHandler m =>
  MonadThrow String m =>
  LoginHandler m =>
  MonadStore Store.Action Store.Store m =>
  Action -> H.HalogenM State Action () output m Unit
handleAction = case _ of
  UpdateTimeLine -> updateMessages
  Initialize -> updateMessages
  SetText text -> H.modify_ _ { text = text }
  Post text -> handlePost text
  Fav id -> handleFav id

handlePost ::
  forall output m.
  MonadAff m =>
  MessagesHandler m =>
  String -> H.HalogenM State Action () output m Unit
handlePost text = do
  postMessage text
  updateMessages

-- | 二回目に押したなら解除
handleFav ::
  forall output m.
  MonadAff m =>
  MessagesHandler m =>
  LoginHandler m =>
  MonadThrow String m =>
  MonadStore Store.Action Store.Store m =>
  Int -> H.HalogenM State Action () output m Unit
handleFav id = do
  res <- whoami
  Profile prof <- fromMaybe (throwError "ログインしてください") $ map pure $ res
  resMessages <- getMessage id
  Message message <- fromMaybe (throwError "ログインしてください") $ map pure $ resMessages
  if prof.id `elem` message.fav_users then
    unfavMessage id
  else
    favMessage id
  updateMessages

updateMessages ::
  forall output m.
  MonadAff m =>
  MessagesHandler m =>
  H.HalogenM State Action () output m Unit
updateMessages = do
  messages <- getMessages
  H.liftEffect $ logShow messages
  H.modify_ _ { messages = messages }
