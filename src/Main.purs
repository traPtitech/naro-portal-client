{-
エントリポイント
-}
module Main where

import Prelude
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Console (log)
import Halogen.Aff as HA
import Halogen.Store.Monad (runStoreT)
import Halogen.VDom.Driver (runUI)
import Kuragate.Components.Router as Router
import Kuragate.Store as Store

infix 5 prod2 as ***

prod2 :: Int -> Int
prod2 x = x * 2

execute2 :: (Int -> Int) -> Int -> Int
execute2 f x = f $ f x

main :: Effect Unit
main = do
  log $ show $ execute2 prod2 3

{-
  launchAff_ do
    body <- HA.awaitBody
    root <- runStoreT Store.initialStore Store.reduce Router.component
    runUI root unit body-}
