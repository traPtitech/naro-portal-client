module Kuragate.Data.Profile where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)

newtype Profile
  = Profile { id :: String, name :: String }

derive instance Generic Profile _
instance Show Profile where
  show = genericShow