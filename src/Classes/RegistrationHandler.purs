module Kuragate.Classes.RegistrationHandler where

import Prelude

import Control.Monad.Trans.Class (lift)
import Halogen (HalogenM)
import Kuragate.Data.Requests (RegisterReq, UnRegisterReq)
import Kuragate.Data.ValidID (ValidID)

class
  Monad m <= RegistrationHandler m where
  register :: RegisterReq -> m Unit
  unregister :: UnRegisterReq -> m Unit
  isValidID :: String -> m ValidID

instance RegistrationHandler m => RegistrationHandler (HalogenM state action slots output m) where
  register = lift <<< register
  unregister = lift <<< unregister
  isValidID = lift <<< isValidID