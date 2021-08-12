module Kuragate.Classes.RegistrationHandler where

import Prelude

import Control.Monad.Trans.Class (lift)
import Halogen (HalogenM)

class
  Monad m <= RegistrationHandler m where
  register :: { id :: String, name :: String, password :: String } -> m Unit
  unregister :: { id :: String, password :: String } -> m Unit
  isValidID :: String -> m Boolean

instance RegistrationHandler m => RegistrationHandler (HalogenM state action slots output m) where
  register = lift <<< register
  unregister = lift <<< unregister
  isValidID = lift <<< isValidID