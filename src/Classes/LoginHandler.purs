module Kuragate.Classes.LoginHandler where

import Prelude

import Data.Maybe (Maybe)
import Halogen (HalogenM, lift)
import Kuragate.Data.Profile (Profile)
import Kuragate.Data.Requests (LoginReq)

class
  Monad m <= LoginHandler m where
  login :: LoginReq -> m Boolean
  logout :: m Boolean
  whoami :: m (Maybe Profile)
  updateProfile :: m Boolean

instance LoginHandler m => LoginHandler (HalogenM state action slots output m) where
  login = lift <<< login
  logout = lift logout
  whoami = lift whoami
  updateProfile = lift updateProfile
