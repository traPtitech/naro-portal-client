module Src.Components.Home where

import Prelude
import Data.Array (elem)
import Data.Either (either, note)
import Data.Maybe (Maybe(..))
import Effect.Aff.Class (class MonadAff)
import Effect.Console (log)
import Halogen (lift)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Store.Connect (Connected, connect)
import Halogen.Store.Monad (class MonadStore)
import Halogen.Store.Select (Selector, selectEq)
import Src.APIs (MessageBody(..))
import Src.APIs as APIs
import Src.Profile (Profile(..))
import Src.Store as Store
import Src.Wrapper.Exception (Error(..), except, runExceptT)
import Type.Proxy (Proxy(..))

type Slot id
  = forall q. H.Slot q Void id

_home = Proxy :: Proxy "home"

type State
  = { messages :: APIs.MessagesBody
    , text :: String
    , userProfile :: Maybe Profile
    }

data Action
  = Receive (Connected DerivingState Input)
  | UpdateTimeLine
  | Initialize
  | SetText String
  | Post
  | Fav Int

-- | Storeと同期するStateの選択
type DerivingState
  = Maybe Profile

type Input
  = Unit

-- | StoreからのInputでStoreとStateを同期する関数
deriveState :: Connected DerivingState Input -> State -> State
deriveState conInput = _ { userProfile = conInput.context }

selectDerivingState :: Selector Store.Store DerivingState
selectDerivingState = selectEq \store -> store.userProfile

component :: forall query output m. MonadAff m => MonadStore Store.Action Store.Store m => H.Component query Input output m
component =
  connect selectDerivingState
    $ H.mkComponent
        { initialState: (\x -> deriveState x initialState)
        , render
        , eval: H.mkEval H.defaultEval { handleAction = handleAction, initialize = Just Initialize }
        }

initialState :: State
initialState = { messages: APIs.MessagesBody [], text: "", userProfile: Nothing }

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
        $ map postBlock messages
    ]
  where
  (APIs.MessagesBody messages) = state.messages

postBlock :: forall w. APIs.Message -> HH.HTML w Action
postBlock message = do
  HH.div [ HP.class_ $ H.ClassName "post" ]
    $ [ HH.div_ [ HH.text $ "@" <> message.user_id ]
      , HH.div_ [ HH.text $ message.text ]
      , HH.div_
          $ [ HH.button [ HE.onClick \_ -> Fav message.id ] [ HH.text "❤" ] ]
          <> map (\x -> HH.text $ " " <> x <> " ") message.fav_users
      ]

handleAction :: forall output m. MonadAff m => MonadStore Store.Action Store.Store m => Action -> H.HalogenM State Action () output m Unit
handleAction = case _ of
  UpdateTimeLine -> updateMessages
  Initialize -> updateMessages
  SetText text -> H.modify_ _ { text = text }
  Post -> handlePost
  Fav id -> handleFav id
  Receive input -> do
    H.modify_ $ deriveState input --Storeの同期

handlePost :: forall output m. MonadAff m => H.HalogenM State Action () output m Unit
handlePost = do
  state <- H.get
  result <- runExceptT <<< APIs.postMessage $ APIs.PostMessageRequestBody { text: state.text }
  either failPostMessage successPostMessage result
  where
  failPostMessage = H.liftEffect <<< log <<< show

  successPostMessage _ = updateMessages

-- | 二回目に押したなら解除
handleFav :: forall output m. MonadAff m => MonadStore Store.Action Store.Store m => Int -> H.HalogenM State Action () output m Unit
handleFav id = do
  result <- runExceptT api
  either failPostMessage successPostMessage result
  where
  api = do
    state <- lift H.get
    Profile prof <- except $ note NotLoginError state.userProfile
    (MessageBody message) <- APIs.message id
    if prof.id `elem` message.fav_users then
      APIs.unFav id
    else
      APIs.fav id

  failPostMessage = H.liftEffect <<< log <<< show

  successPostMessage _ = updateMessages

updateMessages :: forall output m. MonadAff m => H.HalogenM State Action () output m Unit
updateMessages = do
  eithermessages <- runExceptT APIs.messages
  either failGetMessages successGetMessages eithermessages
  where
  failGetMessages = H.liftEffect <<< log <<< show

  successGetMessages messages = H.modify_ _ { messages = messages }
