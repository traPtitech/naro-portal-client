module Src.Components.Home where

import Prelude
import Affjax as AX
import Affjax.RequestBody as RequestBody
import Affjax.ResponseFormat as ResponseFormat
import Control.Monad.State (get)
import Data.Argonaut.Core (fromNumber)
import Data.Either (either)
import Data.Generic.Rep (class Generic)
import Data.Int (toNumber)
import Data.Maybe (Maybe(..))
import Effect.Aff.Class (class MonadAff)
import Effect.Console (log)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Src.Wrapper.Exception (ExceptT, except, runExceptT)
import Src.Wrapper.Generic (jsonToRecord, recordToJson)
import Type.Proxy (Proxy(..))

type Slot id
  = forall q. H.Slot q Void id

_home = Proxy :: Proxy "home"

type PostData  --命名規則が微妙(サーバー側ではコレがPostという型名)
  = { id :: Int
    , user_id :: String
    , text :: String
    , post_time :: String
    }

type Post
  = { post_data :: PostData
    , fav_users :: Array String
    }

newtype GetPostsResponseBody
  = GetPostsResponseBody (Array Post)

newtype PostRequestBody
  = PostRequestBody { text :: String }

derive instance genericgetPostResponseBody :: Generic GetPostsResponseBody _

derive instance genericPostRequestBody :: Generic PostRequestBody _

type State
  = { posts :: Array Post
    , text :: String
    }

data Action
  = UpdateTimeLine
  | Initialize
  | SetText String
  | Post
  | Fav Int

component :: forall query input output m. MonadAff m => H.Component query input output m
component =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval H.defaultEval { handleAction = handleAction, initialize = Just Initialize }
    }

initialState :: forall input. input -> State
initialState _ = { posts: [], text: "" }

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
        $ map postBlock state.posts
    ]

postBlock :: forall w. Post -> HH.HTML w Action
postBlock post =
  HH.div [ HP.class_ $ H.ClassName "post" ]
    $ [ HH.div_ [ HH.text $ "@" <> post.post_data.user_id ]
      , HH.div_ [ HH.text $ post.post_data.text ]
      , HH.div_ $ [ HH.button [ HE.onClick \_ -> Fav post.post_data.id ] [ HH.text "❤" ] ] <> map (\x -> HH.text $ " " <> x <> " ") post.fav_users
      ]

handleAction :: forall output m. MonadAff m => Action -> H.HalogenM State Action () output m Unit
handleAction = case _ of
  UpdateTimeLine -> updatePosts
  Initialize -> updatePosts
  SetText text -> H.modify_ _ { text = text }
  Post -> do
    state <- get
    _ <- runExceptT <<< postAPI $ PostRequestBody { text: state.text }
    H.modify_ _ { text = "" }
    updatePosts
  Fav postId -> do
    _ <- H.liftAff $ AX.post ResponseFormat.ignore "api/favpost" <<< Just <<< RequestBody.json <<< fromNumber <<< toNumber $ postId
    pure unit
    updatePosts

postAPI :: forall m. Monad m => MonadAff m => PostRequestBody -> ExceptT m Unit
postAPI req = do
  requestJson <- recordToJson req
  _ <- H.liftAff <<< AX.post ResponseFormat.ignore "api/updatepost" <<< Just <<< RequestBody.json $ requestJson
  pure unit

getPostsAPI :: forall m. MonadAff m => ExceptT m GetPostsResponseBody
getPostsAPI = do
  result <- H.liftAff $ AX.get ResponseFormat.json "api/posts"
  response <- except result
  jsonToRecord response.body

updatePosts :: forall output m. MonadAff m => H.HalogenM State Action () output m Unit
updatePosts = do
  eitherposts <- runExceptT getPostsAPI
  either (H.liftEffect <<< log <<< show) (\posts -> H.modify_ _ { posts = (case _ of GetPostsResponseBody x -> x) $ posts }) eitherposts
