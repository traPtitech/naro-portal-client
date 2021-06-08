{-
エントリポイント 
-}
module Src.App where

import Prelude
import Effect (Effect)
import Effect.Aff (launchAff_)
import Halogen.Aff as HA
import Halogen.Store.Monad (runStoreT)
import Halogen.VDom.Driver (runUI)
import Src.Router as Router
import Src.Store as Store

main :: Effect Unit
main =
  launchAff_ do
    body <- HA.awaitBody
    root <- runStoreT Store.initialStore Store.reduce Router.component
    runUI root unit body
