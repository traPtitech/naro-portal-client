{-
ルート(ページ)のまとめ
ハッシュをページに変換、ページをハッシュに変換などします
-}
module Src.Routes where

import Prelude
import Data.Either (either)
import Data.Foldable (oneOf)
import Routing (match)
import Routing.Match (end, lit)

data Page
  = HomePage
  | LoginPage
  | SignupPage
  | SettingsPage
  | NotFoundPage

derive instance eqPage :: Eq Page

-- | ハッシュ以降の文字列を受け取って該当するページを返す
hashToPage :: String -> Page
hashToPage = either (const NotFoundPage) identity <<< eitherRouter
  where
  eitherRouter =
    match
      $ oneOf
          [ HomePage <$ lit "home"
          , SettingsPage <$ lit "settings"
          , LoginPage <$ lit "login"
          , SignupPage <$ lit "signup"
          , pure HomePage
          ]
      <* end

-- | hashToPage <<< pageToHash = idが成り立つ
pageToHash :: Page -> String
pageToHash = case _ of
  HomePage -> "home"
  SettingsPage -> "settings"
  LoginPage -> "login"
  SignupPage -> "signup"
  NotFoundPage -> "notfound"

-- | ログインが必要かどうかを返す
loginRequired :: Page -> Boolean
loginRequired = case _ of
  HomePage -> true
  LoginPage -> false
  SettingsPage -> true
  SignupPage -> false
  NotFoundPage -> false

-- | ログインしていない時、ログインを必要とするページにアクセスしようとした際に飛ばされるページ
notLoginDefaultPage :: Page
notLoginDefaultPage = LoginPage
