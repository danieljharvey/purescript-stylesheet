module Test.Main where

import Prelude

import CSDom (addRule, initialCsDom, getRules,fromStyleRuleList)
import CSSom (StyleRule(..))
import Data.List (fromFoldable, head, length)
import Data.Map as Map
import Data.Maybe (Maybe(Just))
import Effect (Effect)
import Test.Unit (suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)

main :: Effect Unit
main = runTest do
  suite "addRule" do
    test "addRule" do
      Assert.assert "Adding a new rule works" $ Map.size ((\a -> a.cssRules) (addRule initialCsDom (StyleRule "box" "color: red;"))) == 1
    test "getRules" do
      let new = StyleRule "box" "color: red;"
      let added = addRule initialCsDom new
      let found = head $ getRules added
      Assert.assert "Can get the style out we just put in" $ found == Just new
    test "fromStyleRuleList" do
      let items = fromFoldable [StyleRule "first" "color: red;", StyleRule "second" "color: blue;"]
      let csDom = fromStyleRuleList "Hello" items
      Assert.assert "Builds a convincing thing" $ length (getRules csDom) == 2
      let items2 = fromFoldable [StyleRule "first" "color: red;", StyleRule "first" "color: blue;"]
      let csDom2 = fromStyleRuleList "Hello" items2
      Assert.assert "Keys overwrite one another" $ length (getRules csDom2) == 1
   
    
