module Kuragate.Data.ValidID where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)

newtype ValidID
  = ValidID Boolean

derive instance Generic ValidID _
instance Show ValidID where
  show = genericShow