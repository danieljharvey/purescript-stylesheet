module CSSTypes where

import Prelude ((<>))
import Data.Map as Map
import Data.Show (class Show)
import Data.Eq (class Eq)
import Effect.Ref
import ChangeStyle (CSSStyleSheet)

type StyleSheetId = String
type CSSClassName = String
type CSSText = String

type CsSom = {
  styleSheet :: CSSStyleSheet,
  csDom :: Ref CsDom
}

data StyleRule = StyleRule CSSClassName CSSText
derive instance eqStyleRule :: Eq StyleRule

instance showStyleRule :: Show StyleRule where
  show (StyleRule class_ text) = "StyleRule: " <> class_ <> ": " <> text

type CssRules = Map.Map CSSClassName CSSText

type CsDom = { styleSheetId :: StyleSheetId
             , cssRules :: CssRules
}
