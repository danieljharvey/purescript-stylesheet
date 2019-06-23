module Test.Main where

import Prelude (Unit, discard, ($), (==))

import Data.HashMap as HM
import Data.List (fromFoldable, head, length)
import Data.Maybe (Maybe(Just))
import Effect (Effect)
import Test.Unit (suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)

import PursUI

main :: Effect Unit
main = runTest do
  suite "CSDom" do
    test "addRule" do
      Assert.assert "Adding a new rule works" $
        HM.size ((\a -> a.cssRules) (addRule (fromName "what") (ClassRule
                 (CSSClassName "box") (CSSText "color: red;")))) == 1
    test "getRules" do
      let new = ClassRule 
                  (CSSClassName "box") 
                  (CSSText "color: red;")
      let added = addRule (fromName "yes") new
      let found = head $ getRules added
      Assert.assert "Can get the style out we just put in" $ found == Just new
    test "getRules 2" do
      let first = ClassRule 
                    (CSSClassName "box")
                    (CSSText "color: red;")
      let second = ClassRule 
                    (CSSClassName "hat")
                    (CSSText "color: green;")
      let added = addRule (addRule (fromName "no") second) first
      let found = head $ getRules added
      Assert.assert "Can get the style out we just put in" $ found == Just first
    test "fromStyleRuleList" do
      let items = fromFoldable [ ClassRule 
                                  (CSSClassName "first") 
                                  (CSSText "color: red;")
                               , ClassRule
                                  (CSSClassName "second")
                                  (CSSText "color: blue;")
                               ]
      let csDom = fromStyleRuleList "Hello" items
      Assert.assert "Builds a convincing thing" $ length (getRules csDom) == 2
      let items2 = fromFoldable [ ClassRule 
                                    (CSSClassName "first")
                                    (CSSText "color: red;")
                                , ClassRule 
                                    (CSSClassName "first")
                                    (CSSText "color: blue;")
                                ]
      let csDom2 = fromStyleRuleList "Hello" items2
      Assert.assert "Keys overwrite one another" $ length (getRules csDom2) == 1
    test "updateFromClassRuleList" do
      let items = fromFoldable [ ClassRule 
                                  (CSSClassName "first")
                                  (CSSText "color: red;")
                               , ClassRule 
                                  (CSSClassName "second")
                                  (CSSText "color: blue;")
                               ]
      let csDom = fromStyleRuleList "Hello" items
      Assert.assert "Original stylesheet" $ length (getRules csDom) == 2
      let items2 = fromFoldable [ ClassRule 
                                    (CSSClassName "third")
                                    (CSSText "color: red;")
                                , ClassRule 
                                    (CSSClassName "fourth")
                                    (CSSText "color: blue;")
                                ]
      let csDom2 = updateFromStyleRuleList csDom items2
      Assert.assert "New items added to the stylesheet" $ length (getRules csDom2) == 4
    test "getUpdated when the same" do
      let items = fromFoldable [ ClassRule 
                                  (CSSClassName "first")
                                  (CSSText "color: red;")
                               , ClassRule 
                                  (CSSClassName "second")
                                  (CSSText "color: blue;")
                               ]
      let csDom = fromStyleRuleList "Hello" items
      Assert.assert "Two identical sheets return nothing" $ HM.size (getUpdated csDom.cssRules csDom.cssRules) == 0
    test "getUpdated when different keys" do
      let items = fromFoldable [ ClassRule 
                                  (CSSClassName "first")
                                  (CSSText "color: red;")
                               ]
      let items2 = fromFoldable [ ClassRule 
                                    (CSSClassName "first")
                                    (CSSText "color: red;")
                                , ClassRule 
                                    (CSSClassName "third")
                                    (CSSText "color: blue;")
                                ]
      let csDom = fromStyleRuleList "Hello" items
      let csDom2 = fromStyleRuleList "Hello2" items2
      Assert.assert "One sheet with a new key returns the difference" $ HM.size (getUpdated csDom.cssRules csDom2.cssRules) == 1
    test "getUpdated when different values" do
      let items = fromFoldable [ ClassRule 
                                  (CSSClassName "first")
                                  (CSSText "color: red;")
                               ]
      let items2 = fromFoldable [ ClassRule 
                                    (CSSClassName "first")
                                    (CSSText "color: blue;")
                                ]
      let csDom = fromStyleRuleList "Hello" items
      let csDom2 = fromStyleRuleList "Hello2" items2
      Assert.assert "One sheet with a new key returns the difference" $ HM.size (getUpdated csDom.cssRules csDom2.cssRules) == 1
    test "getUpdatedFromDom" do
      let items = fromFoldable [ ClassRule 
                                  (CSSClassName "first")
                                  (CSSText "color: red;")
                               ]
      let items2 = fromFoldable [ ClassRule 
                                  (CSSClassName "first") 
                                  (CSSText "color: blue;")
                                ]
      let csDom = fromStyleRuleList "Hello" items
      let csDom2 = fromStyleRuleList "Hello2" items2
      Assert.assert "Compares two csDoms and returns list" $ (length $ getUpdatedFromDom csDom csDom2) == 1
