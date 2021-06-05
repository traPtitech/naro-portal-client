{-
エントリポイント 
ルーティングをしてそれぞれのページのコンポーネントを読み込む
-}
module Main where

import Prelude
import Affjax as AX
import Affjax.ResponseFormat as ResponseFormat
import Control.Monad.State (class MonadState)
import Data.Argonaut.Core (Json, fromString, jsonNull, stringify)
import Data.Either (Either(..))
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Data.String as Str
import Data.String.CodePoints (codePointFromChar)
import Effect (Effect)
import Effect.Aff.Class (class MonadAff)
import Effect.Class.Console (log)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Query.Event (eventListener)
import Halogen.Subscription as HS
import Halogen.VDom.Driver (runUI)
import Web.HTML (window)
import Web.HTML.Event.HashChangeEvent (fromEvent, newURL)
import Web.HTML.Event.HashChangeEvent.EventTypes (hashchange)
import Web.HTML.Location as Location
import Web.HTML.Window (toEventTarget, location)
import Library (makeJsonRequest)

main :: Effect Unit
main =
  HA.runHalogenAff do
    body <- HA.awaitBody
    runUI component unit body

data Page
  = HomePage
  | LoginPage
  | NotFoundPage

type State
  = { posts :: Json, currentPage :: Page }

data Action
  = LoginAction
  | LogoutAction
  | InitializeAction
  | HashChangeAction String

newtype LoginReqestBody
  = LoginReqestBody { id :: String, password :: String }

derive instance genericLoginReqestBody :: Generic LoginReqestBody _

yukikurage :: LoginReqestBody
yukikurage = LoginReqestBody { id: "yukikurage", password: "yukikurage" }

component :: forall query input output m. MonadAff m => H.Component query input output m
component =
  H.mkComponent
    { initialState
    , render
    , eval:
        H.mkEval
          $ H.defaultEval
              { handleAction = handleAction
              , initialize = Just InitializeAction
              }
    }

initialState :: forall input. input -> State
initialState _ = { posts: jsonNull, currentPage: HomePage }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div [ HP.class_ $ H.ClassName "app" ]
    [ HH.div [ HP.class_ $ H.ClassName "navigation_bar" ] navigationBar
    , HH.div_ []
    , HH.div_ (pageContents state)
    ]

-- | メインコンテンツ
pageContents :: forall w. State -> Array (HH.HTML w Action)
pageContents state = case state.currentPage of
  HomePage -> [ HH.div_ [ HH.text $ stringify state.posts ] ]
  LoginPage ->
    [ HH.button [ HE.onClick (\_ -> LoginAction) ] [ HH.text "Login" ]
    , HH.button [ HE.onClick \_ -> LogoutAction ] [ HH.text "Logout" ]
    ]
  NotFoundPage -> [ HH.text "Page Not Found" ]

-- | ナビゲーションバーを作成
navigationBar :: forall w. Array (HH.HTML w Action)
navigationBar =
  [ HH.a [ HP.href ("#" <> "login") ] [ HH.text "Login" ]
  , HH.text " | "
  , HH.a [ HP.href ("#" <> "home") ] [ HH.text "Home" ]
  ]

updatePosts :: forall a. Bind a => MonadAff a => MonadState State a => a Unit
updatePosts = do
  result2 <- H.liftAff $ AX.get ResponseFormat.json "api/posts"
  posts <-
    H.liftEffect
      $ case result2 of
          Left err -> log (AX.printError err) *> (pure $ fromString "")
          Right res -> pure res.body
  H.modify_ _ { posts = posts }

handleAction :: forall output m. MonadAff m => Action -> H.HalogenM State Action () output m Unit
handleAction = case _ of
  LoginAction -> do
    _ <- H.liftAff $ AX.post ResponseFormat.ignore "api/login" (makeJsonRequest yukikurage)
    updatePosts
  LogoutAction -> do
    _ <- H.liftAff $ AX.get ResponseFormat.ignore "api/logout"
    updatePosts
  InitializeAction -> do
    emitter <- H.liftEffect hashChangeEmitter
    _ <- H.subscribe emitter
    initHash <- H.liftEffect $ Location.hash =<< location =<< window
    -- ↑再読み込み時にhashchangeが発火しない現象の対策
    H.liftEffect $ log initHash
    H.modify_ _ { currentPage = router initHash }
  HashChangeAction str -> do
    let
      newHash = Str.dropWhile (_ /= codePointFromChar '#') str
    log newHash
    H.modify_ _ { currentPage = router newHash }

-- | ハッシュ以降の文字列を受け取って該当するページを返します
router :: String -> Page
router = case _ of
  "" -> HomePage
  "#home" -> HomePage
  "#login" -> LoginPage
  _ -> NotFoundPage

-- ハッシュ以降のURLの変化を検知するEmitter
hashChangeEmitter :: Effect (HS.Emitter Action)
hashChangeEmitter = do
  targetWindow <- toEventTarget <$> window
  pure
    $ eventListener
        hashchange
        targetWindow
        (\ev -> HashChangeAction <<< newURL <$> fromEvent ev)
