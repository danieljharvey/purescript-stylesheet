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
      Assert.assert "Seems fine" $ "yes" == "yes"
