module Test.Main where

import Prelude (Unit, discard, ($), (==))

import CSSTypes
import CSDom (addRule, fromStyleRuleList, getRules, initialCsDom, updateFromStyleRuleList, getUpdated, getUpdatedFromDom)
import Data.List (fromFoldable, head, length)
import Data.Map as Map
import Data.Maybe (Maybe(Just))
import Effect (Effect)
-- import Effect.Console
-- import Effect.Class
import Test.Unit (suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)

main :: Effect Unit
main = runTest do
  suite "CSDom" do
    test "addRule" do
      Assert.assert "Adding a new rule works" $ Map.size ((\a -> a.cssRules) (addRule initialCsDom (StyleRule "box" "color: red;"))) == 1
    test "getRules" do
      let new = StyleRule "box" "color: red;"
      let added = addRule initialCsDom new
      let found = head $ getRules added
      Assert.assert "Can get the style out we just put in" $ found == Just new
    test "getRules 2" do
      let first = StyleRule "box" "color: red;"
      let second = StyleRule "hat" "color: green;"
      let added = addRule (addRule initialCsDom second) first
      let found = head $ getRules added
      Assert.assert "Can get the style out we just put in" $ found == Just first
    test "fromStyleRuleList" do
      let items = fromFoldable [StyleRule "first" "color: red;", StyleRule "second" "color: blue;"]
      let csDom = fromStyleRuleList "Hello" items
      Assert.assert "Builds a convincing thing" $ length (getRules csDom) == 2
      let items2 = fromFoldable [StyleRule "first" "color: red;", StyleRule "first" "color: blue;"]
      let csDom2 = fromStyleRuleList "Hello" items2
      Assert.assert "Keys overwrite one another" $ length (getRules csDom2) == 1
    test "updateFromStyleRuleList" do
      let items = fromFoldable [StyleRule "first" "color: red;", StyleRule "second" "color: blue;"]
      let csDom = fromStyleRuleList "Hello" items
      Assert.assert "Original stylesheet" $ length (getRules csDom) == 2
      let items2 = fromFoldable [StyleRule "third" "color: red;", StyleRule "fourth" "color: blue;"]
      let csDom2 = updateFromStyleRuleList csDom items2
      Assert.assert "New items added to the stylesheet" $ length (getRules csDom2) == 4
    test "getUpdated when the same" do
      let items = fromFoldable [StyleRule "first" "color: red;", StyleRule "second" "color: blue;"]
      let csDom = fromStyleRuleList "Hello" items
      Assert.assert "Two identical sheets return nothing" $ Map.size (getUpdated csDom.cssRules csDom.cssRules) == 0
    test "getUpdated when different keys" do
      let items = fromFoldable [StyleRule "first" "color: red;"]
      let items2 = fromFoldable [StyleRule "first" "color: red;", StyleRule "third" "color: blue;"]
      let csDom = fromStyleRuleList "Hello" items
      let csDom2 = fromStyleRuleList "Hello2" items2
      Assert.assert "One sheet with a new key returns the difference" $ Map.size (getUpdated csDom.cssRules csDom2.cssRules) == 1
    test "getUpdated when different values" do
      let items = fromFoldable [StyleRule "first" "color: red;"]
      let items2 = fromFoldable [StyleRule "first" "color: blue;"]
      let csDom = fromStyleRuleList "Hello" items
      let csDom2 = fromStyleRuleList "Hello2" items2
      Assert.assert "One sheet with a new key returns the difference" $ Map.size (getUpdated csDom.cssRules csDom2.cssRules) == 1
    test "getUpdatedFromDom" do
      let items = fromFoldable [StyleRule "first" "color: red;"]
      let items2 = fromFoldable [StyleRule "first" "color: blue;"]
      let csDom = fromStyleRuleList "Hello" items
      let csDom2 = fromStyleRuleList "Hello2" items2
      Assert.assert "Compares two csDoms and returns list" $ (length $ getUpdatedFromDom csDom csDom2) == 1
