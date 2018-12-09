module Main where

import Prelude (Unit, bind, discard, pure, unit, ($))
import Effect (Effect)
import CSSom

foreign import calculateInterest :: Number -> Number

foreign import data CSSStyleSheet :: Type

main :: Effect Unit
main = do
  styles <- createStyleTagEff "poo"
  putStyleEff styles $ StyleRule "flop" "color: red;"
  pure unit
