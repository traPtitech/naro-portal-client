module Kuragate.Classes.MessagesHandler where

import Prelude

import Data.Maybe (Maybe)
import Halogen (HalogenM, lift)
import Kuragate.Data.Message (Message, Messages)

class
  Monad m <= MessagesHandler m where
  getMessages :: m Messages
  getMessage :: Int -> m (Maybe Message)
  postMessage :: String -> m Unit
  deleteMessage :: Int -> m Unit
  favMessage :: Int -> m Unit
  unfavMessage :: Int -> m Unit

instance MessagesHandler m => MessagesHandler (HalogenM state action slots output m) where
  getMessages = lift getMessages
  getMessage = lift <<< getMessage
  postMessage = lift <<< postMessage
  deleteMessage = lift <<< deleteMessage
  favMessage = lift <<< favMessage
  unfavMessage = lift <<< unfavMessage