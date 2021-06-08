module Src.Components.Home where

import Prelude
import Affjax as AX
import Affjax.RequestBody as RequestBody
import Affjax.ResponseFormat as ResponseFormat
import Control.Monad.Except (runExcept)
import Control.Monad.State (class MonadState)
import Data.Argonaut.Core (fromNumber, fromString, stringify)
import Data.Either (Either(..), either)
import Data.Generic.Rep (class Generic)
import Data.Int (toNumber)
import Data.Maybe (Maybe(..))
import Effect.Aff.Class (class MonadAff)
import Foreign.Generic (decodeJSON)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
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

newtype PostRequestBody
  = PostRequestBody { text :: String }

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
  Post -> pure unit {- do
    state <- H.get
    _ <- H.liftAff $ AX.post ResponseFormat.ignore "api/updatepost" $ makeJsonRequest $ PostRequestBody { text: state.text }
    H.modify_ _ { text = "" }
    updatePosts-}
  Fav postId -> do
    _ <- H.liftAff $ AX.post ResponseFormat.ignore "api/favpost" $ Just $ RequestBody.json $ fromNumber $ toNumber $ postId
    updatePosts

-- | 投稿一覧を更新
updatePosts :: forall a. Bind a => MonadAff a => MonadState State a => a Unit
updatePosts = do
  result <- H.liftAff $ AX.get ResponseFormat.json "api/posts"
  postsJSON <-
    H.liftEffect
      $ case result of
          Left _ -> pure $ fromString ""
          Right res -> pure res.body
  let
    postsEither = runExcept $ decodeJSON $ stringify postsJSON
  either (const $ pure unit) (\posts -> H.modify_ _ { posts = posts }) postsEither
