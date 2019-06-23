module PursUI.Test where

import Prelude (Unit, bind, pure, unit, ($))
import Data.List (fromFoldable)
import Effect (Effect)
import Effect.Timer (setInterval)

import PursUI

main :: Effect Unit
main = do
  styles <- createBlankStyleSheet "poo"
  _ <- setInterval 100 (changeStyle1 styles)
  _ <- setInterval 150 (changeStyle2 styles)
  _ <- setInterval 500 (changeStyle3 styles)
  pure unit

changeStyle1 :: PursUI -> Effect Unit
changeStyle1 s = do
  addStyleEff s 
    $ fromFoldable
       [ ClassRule 
          (CSSClassName "flop") 
          (CSSText "color: green;")
       , ClassRule 
          (CSSClassName "other")
          (CSSText "font-size: 100px;")
       ]

changeStyle2 :: PursUI -> Effect Unit
changeStyle2 s = do
  let styleRule1 = ClassRule 
                    (CSSClassName "flop") 
                    (CSSText "color: red;")
  let styleRule2 = ClassRule
                    (CSSClassName "bodydiv")
                    (CSSText "background-color: grey; font-size: 30px;")

  addStyleEff s $ fromFoldable [ styleRule1, styleRule2 ]

changeStyle3 :: PursUI -> Effect Unit
changeStyle3 s = do
  let styleRule1 = ClassRule 
                     (CSSClassName "flop")
                     (CSSText "color: blue; font-size: 30px;")
  let styleRule2 = ClassRule 
                     (CSSClassName "bodydiv")
                     (CSSText "background-color: black; font-size: 10px;")
  addStyleEff s $ fromFoldable [ styleRule1, styleRule2 ]
