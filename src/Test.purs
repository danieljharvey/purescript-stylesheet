module PursUI.Test where

import Prelude
import Data.List (fromFoldable)
import Effect (Effect)
import Effect.Console (log)
import Effect.Timer (setInterval)

import PursUI

main :: Effect Unit
main = do
  styles <- createBlankStyleSheet "poo"
  _ <- setInterval 100 (changeStyle1 styles)
  _ <- setInterval 150 (changeStyle2 styles)
  _ <- setInterval 500 (changeStyle3 styles)
  pure unit

changeStyle1 :: CsSom -> Effect Unit
changeStyle1 s = do
  addStyleEff s $ fromFoldable [ StyleRule "flop" "color: green;", StyleRule "other" "font-size: 100px;"]

changeStyle2 :: CsSom -> Effect Unit
changeStyle2 s = do
  let styleRule1 = StyleRule "flop" "color: red;"
  let styleRule2 = StyleRule "bodydiv" "background-color: grey; font-size: 30px;"
  addStyleEff s $ fromFoldable [ styleRule1, styleRule2 ]

changeStyle3 :: CsSom -> Effect Unit
changeStyle3 s = do
  let styleRule1 = StyleRule "flop" "color: blue; font-size: 30px;"
  let styleRule2 = StyleRule "bodydiv" "background-color: black; font-size: 10px;"
  addStyleEff s $ fromFoldable [ styleRule1, styleRule2 ]
