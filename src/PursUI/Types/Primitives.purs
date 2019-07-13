module PursUI.Types.Primitives where

import Prelude

import Data.Hashable (class Hashable)

newtype StyleSheetId 
  = StyleSheetId String

newtype CSSClassName 
  = CSSClassName String

derive newtype instance eqCSSClassName :: Eq CSSClassName
derive newtype instance ordCSSClassName :: Ord CSSClassName
derive newtype instance hashableCSSClassName :: Hashable CSSClassName

newtype CSSSelector
  = CSSSelector String

derive newtype instance eqCSSSelector :: Eq CSSSelector
derive newtype instance ordCSSSelector :: Ord CSSSelector
derive newtype instance hashableCSSSelector :: Hashable CSSSelector

newtype CSSText = 
  CSSText String

derive newtype instance eqCSSText :: Eq CSSText
derive newtype instance ordCSSText :: Ord CSSText
derive newtype instance showCSSText :: Show CSSText
derive newtype instance semigroupCSSText :: Semigroup CSSText
derive newtype instance monoidCSSText :: Monoid CSSText

newtype MediaQueryText
  = MediaQueryText String

derive newtype instance eqMediaQueryText :: Eq MediaQueryText
derive newtype instance ordMediaQueryText :: Ord MediaQueryText
derive newtype instance semigroupMediaQueryText :: Semigroup MediaQueryText
derive newtype instance monoidMediaQueryText :: Monoid MediaQueryText
derive newtype instance showMediaQueryText :: Show MediaQueryText

data InsertRule
  = InsertRule CSSSelector CSSText

-- rule along with helpful things
type UnpackedRule a 
  = { id       :: Int
    , item     :: a
    , selector :: CSSSelector
    , ruleText :: CSSText
    } 

type UnpackedMediaRule a
  = { id      :: Int
    , item    :: a
    , query   :: MediaQueryText
    }
