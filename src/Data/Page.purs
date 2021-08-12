module Kuragate.Data.Page where

import Prelude
import Data.Either (either)
import Data.Foldable (oneOf)
import Routing (match)
import Routing.Match (end, lit, str)

type ID
  = String

data Page
  = LoginPage
  | RegisterPage
  | SettingsPage
  | ProfilePage ID
  | HomePage
  | NotFoundPage

derive instance Eq Page

hashToPage :: String -> Page
hashToPage = either (const NotFoundPage) identity <<< eitherRouter
  where
  eitherRouter =
    match
      $ oneOf
          [ HomePage <$ lit "home"
          , SettingsPage <$ lit "settings"
          , LoginPage <$ lit "login"
          , RegisterPage <$ lit "register"
          , ProfilePage <$> (lit "profiles" *> str)
          , pure HomePage
          ]
      <* end

pageToHash :: Page -> String
pageToHash = case _ of
  LoginPage -> "login"
  RegisterPage -> "register"
  SettingsPage -> "settings"
  ProfilePage id -> "profiles/" <> id
  HomePage -> "home"
  NotFoundPage -> "notFound"

loginRequired :: Page -> Boolean
loginRequired = case _ of
  LoginPage -> false
  RegisterPage -> false
  SettingsPage -> true
  ProfilePage _ -> true
  HomePage -> true
  NotFoundPage -> false

notLoginDefaultPage :: Page
notLoginDefaultPage = LoginPage
