module Kuragate.Classes.NavigationHandler where

-- hashを変更する

import Prelude

import Halogen (HalogenM, lift)
import Kuragate.Data.Page (Page)

class Monad m <= NavigationHandler m where
  navigate :: Page -> m Unit

instance NavigationHandler m => NavigationHandler (HalogenM state action slots output m) where
  navigate = lift <<< navigate