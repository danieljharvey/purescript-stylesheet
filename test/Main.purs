module Test.Main where

import Prelude (Unit, ($), (==))

import Effect (Effect)
import Test.Unit (suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)

main :: Effect Unit
main = runTest do
  suite "Stylesheet" do
    test "addRule" do
      Assert.assert "Seems fine" $ "yes" == "yes"
