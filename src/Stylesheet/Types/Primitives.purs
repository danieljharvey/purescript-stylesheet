module Stylesheet.Types.Primitives where

import Prelude

import Data.Hashable (class Hashable, hash)

-- | Unique ID for stylesheet in DOM
newtype StylesheetId 
  = StylesheetId String

-- | CSS Selectors used in DOM, currently we only use class selectors
data CSSSelector
  = CSSClassSelector String

derive instance eqCSSSelector :: Eq CSSSelector  
derive instance ordCSSSelector :: Ord CSSSelector
instance hashableCSSSelector :: Hashable CSSSelector where
  hash (CSSClassSelector s) = hash s

instance showCSSSelector :: Show CSSSelector where
  show (CSSClassSelector s) = "." <> s

-- | CSS rules in text form
newtype CSSText = 
  CSSText String

derive newtype instance eqCSSText :: Eq CSSText
derive newtype instance ordCSSText :: Ord CSSText
derive newtype instance semigroupCSSText :: Semigroup CSSText
derive newtype instance monoidCSSText :: Monoid CSSText
derive newtype instance hashableCSSText :: Hashable CSSText

instance showCSSText :: Show CSSText where
  show (CSSText s) = s

-- | Description of media query
newtype MediaQueryText
  = MediaQueryText String

derive newtype instance eqMediaQueryText :: Eq MediaQueryText
derive newtype instance ordMediaQueryText :: Ord MediaQueryText
derive newtype instance semigroupMediaQueryText :: Semigroup MediaQueryText
derive newtype instance monoidMediaQueryText :: Monoid MediaQueryText

instance showMediaQueryText :: Show MediaQueryText where
  show (MediaQueryText s) = s

-- | Data structure used internally to describe a single CSS rule
data InsertRule
  = InsertRule CSSSelector CSSText

instance showInsertRule :: Show InsertRule where
  show (InsertRule css text) = show css <> " { " <> show text <> " }"

-- | A complete single rule or nested media rule
data InsertMediaRule
  = InsertMediaQuery MediaQueryText (Array InsertMediaRule)
  | InsertStyleRule InsertRule

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
