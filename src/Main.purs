module Main where

import Data.List (fromFoldable)
import CSSTypes (StyleRule(..), CsSom)
import CSSom (createBlankStyleSheet, addStyleEff)
import Effect (Effect)
import Effect.Timer (setInterval)
import Prelude (Unit, bind, discard, pure, unit, ($))

main :: Effect Unit
main = do
  styles <- createBlankStyleSheet "poo"
  _ <- setInterval 1000 (changeStyle1 styles)
  _ <- setInterval 1500 (changeStyle2 styles)
  pure unit

changeStyle1 :: CsSom -> Effect Unit
changeStyle1 s = do
  _ <- addStyleEff s $ fromFoldable [StyleRule "flop" "color: green;"]
  pure unit

changeStyle2 :: CsSom -> Effect Unit
changeStyle2 s = do
  _ <- addStyleEff s $ fromFoldable [StyleRule "flop" "color: red;"]
  pure unit
