module CSSTypes where

import Data.Map as Map
import Data.Eq (class Eq)

import ChangeStyle (CSSStyleSheet)

type StyleSheetId = String
type CSSClassName = String
type CSSText = String

type CsSom = {
  styleSheet :: CSSStyleSheet,
  csDom :: CsDom
}

data StyleRule = StyleRule CSSClassName CSSText
derive instance eqStyleRule :: Eq StyleRule

type CssRules = Map.Map CSSClassName CSSText

type CsDom = { styleSheetId :: StyleSheetId
             , cssRules :: CssRules
}
