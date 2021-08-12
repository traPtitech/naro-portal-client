{-
エントリポイント
-}
module Main where

import Prelude
import Effect (Effect)
import Effect.Aff (launchAff_)
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)
import Kuragate.AppM (runAppM)
import Kuragate.Components.Router as Router
import Kuragate.Store as Store

main :: Effect Unit
main = do
  launchAff_ do
    body <- HA.awaitBody
    root <- runAppM Store.initialStore Store.reduce Router.component
    runUI root unit body
