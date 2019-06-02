module PursUI.Internal.Types where

import Prelude
import Data.Map as Map
import Effect.Ref (Ref)
import PursUI.Internal.CSSOM (CSSStyleSheet)

type StyleSheetId = String
type CSSClassName = String
type CSSText = String

type CsSom = {
  styleSheet :: CSSStyleSheet,
  csDom :: Ref VirtualStyleSheet
}

data StyleRule = StyleRule CSSClassName CSSText
derive instance eqStyleRule :: Eq StyleRule

instance showStyleRule :: Show StyleRule where
  show (StyleRule class_ text) = "StyleRule: " <> class_ <> ": " <> text

type CssRules = Map.Map CSSClassName CSSText

type VirtualStyleSheet 
  = { virtualStyleSheetId :: StyleSheetId
    , cssRules            :: CssRules
    }

type Sheet (p :: Symbol) 
  = { sheety :: CssRules }

mySheet :: Sheet "main"
mySheet = { sheety: mempty }
