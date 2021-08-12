module Kuragate.Classes.LoginHandler where

import Prelude

import Data.Maybe (Maybe)
import Halogen (HalogenM, lift)
import Kuragate.Data.Profile (Profile)

class
  Monad m <= LoginHandler m where
  login :: { id :: String, password :: String } -> m Unit
  logout :: m Unit
  whoami :: m (Maybe Profile)
  updateProfile :: m Unit

instance LoginHandler m => LoginHandler (HalogenM state action slots output m) where
  login = lift <<< login
  logout = lift logout
  whoami = lift whoami
  updateProfile = lift updateProfile
