module PursUI.Internal.Types where

import Prelude

import Data.Hashable (class Hashable)

newtype StyleSheetId 
  = StyleSheetId String

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

newtype MediaQueryText
  = MediaQueryText String

derive newtype instance eqMediaQueryText :: Eq MediaQueryText
derive newtype instance ordMediaQueryText :: Ord MediaQueryText
derive newtype instance semigroupMediaQueryText :: Semigroup MediaQueryText
derive newtype instance monoidMediaQueryText :: Monoid MediaQueryText
