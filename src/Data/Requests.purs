module Kuragate.Data.Requests where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)

data LoginReq
  = LoginReq { id :: String, password :: String }

derive instance Generic LoginReq _
instance Show LoginReq where
  show = genericShow

data RegisterReq = RegisterReq { id :: String, name :: String, password :: String } 

derive instance Generic RegisterReq _
instance Show RegisterReq where
  show = genericShow

data UnRegisterReq = UnRegisterReq { id :: String, password :: String } 

derive instance Generic UnRegisterReq _
instance Show UnRegisterReq where
  show = genericShow

data PostMessageReq
  = PostMessageReq { text :: String }

derive instance Generic PostMessageReq _
instance Show PostMessageReq where
  show = genericShow