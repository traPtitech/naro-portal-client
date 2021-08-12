module Kuragate.Data.Message where

newtype Message
  = Message
  { id :: Int
  , user_id :: String
  , text :: String
  , postTime :: String
  , fav_users :: Array String
  }
