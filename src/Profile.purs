{-
ユーザーのプロフィール情報に関する諸々
-}
module Src.Profile where

import Prelude
import Data.Generic.Rep (class Generic)

newtype Profile
  = Profile
  { id :: String
  , name :: String
  }

derive instance genericProfile :: Generic Profile _

derive instance eqProfile :: Eq Profile
