module PursUI.Internal.Types where

import Prelude
import Data.Hashable (class Hashable)
import Data.HashMap (HashMap)
import Effect.Ref (Ref)
import PursUI.Internal.CSSOM (CSSStyleSheet)

-- this should be type level so all sheets are known statically
type StyleSheetId 
  = String

newtype CSSClassName 
  = CSSClassName String

derive newtype instance eqCSSClassName :: Eq CSSClassName
derive newtype instance ordCSSClassName :: Ord CSSClassName
derive newtype instance hashableCSSClassName :: Hashable CSSClassName

newtype CSSText = 
  CSSText String

derive newtype instance eqCSSText :: Eq CSSText
derive newtype instance ordCSSText :: Ord CSSText
derive newtype instance semigroupCSSText :: Semigroup CSSText
derive newtype instance monoidCSSText :: Monoid CSSText

type PursUI = {
  styleSheet :: CSSStyleSheet,
  csDom      :: Ref VirtualStyleSheet
}

data StyleRule 
  = ClassRule CSSClassName CSSText

derive instance eqStyleRule :: Eq StyleRule

instance showStyleRule :: Show StyleRule where
  show (ClassRule (CSSClassName class_) (CSSText text)) 
    = "StyleRule: " <> class_ <> ": " <> text

type CssRules 
  = HashMap CSSClassName CSSText

-- our virtual stylesheet is our idea of the stylesheet
-- we add to this
-- and then it is differed so the real one reflects it
type VirtualStyleSheet 
  = { virtualStyleSheetId :: StyleSheetId
    , cssRules            :: CssRules
    }
