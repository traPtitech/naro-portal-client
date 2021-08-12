module Kuragate.Data.Message where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)

type MessageRecord = 
  { id :: Int
  , user_id :: String
  , text :: String
  , post_time :: String
  , fav_users :: Array String
  }
newtype Message
  = Message MessageRecord

newtype Messages = Messages (Array MessageRecord)

derive instance Generic Message _
instance Show Message where
  show = genericShow

derive instance Generic Messages _
instance Show Messages where
  show = genericShow