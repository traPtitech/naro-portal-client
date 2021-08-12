module Kuragate.Components.Home where

import Prelude
import Control.Monad.Error.Class (class MonadThrow, throwError)
import Data.Array (elem)
import Data.Maybe (Maybe(..), fromMaybe)
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Store.Monad (class MonadStore)
import Kuragate.Classes.LoginHandler (class LoginHandler, whoami)
import Kuragate.Classes.MessagesHandler (class MessagesHandler, favMessage, getMessage, getMessages, unfavMessage)
import Kuragate.Data.Message (Message(..))
import Kuragate.Data.Profile (Profile(..))
import Kuragate.Store as Store
import Type.Proxy (Proxy(..))

type Slot id
  = forall q. H.Slot q Void id

_home = Proxy :: Proxy "home"

type State
  = { messages :: Array Message
    , text :: String
    }

data Action
  = UpdateTimeLine
  | Initialize
  | SetText String
  | Post
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
initialState = { messages: [], text: "" }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div_
    [ HH.div_
        [ HH.input
            [ HP.value state.text
            , HE.onValueInput SetText
            ]
        , HH.button [ HE.onClick (\_ -> Post) ] [ HH.text "Post" ]
        ]
    , HH.div_
        $ map postBlock state.messages
    ]

postBlock :: forall w. Message -> HH.HTML w Action
postBlock message = do
  let
    Message extracted = message
  HH.div [ HP.class_ $ H.ClassName "post" ]
    $ [ HH.div_ [ HH.text $ "@" <> extracted.user_id ]
      , HH.div_ [ HH.text $ extracted.text ]
      , HH.div_
          $ [ HH.button [ HE.onClick \_ -> Fav extracted.id ] [ HH.text "❤" ] ]
          <> map (\x -> HH.text $ " " <> x <> " ") extracted.fav_users
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
  Post -> handlePost
  Fav id -> handleFav id

handlePost ::
  forall output m.
  MonadAff m =>
  MessagesHandler m =>
  H.HalogenM State Action () output m Unit
handlePost = do
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
  (Message message) <- getMessage id
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
  H.modify_ _ { messages = messages }
