module PursUI.Types.Primitives where

import Prelude

import Data.Hashable (class Hashable, hash)

newtype StyleSheetId 
  = StyleSheetId String

data CSSSelector
  = CSSClassSelector String

derive instance eqCSSSelector :: Eq CSSSelector  
derive instance ordCSSSelector :: Ord CSSSelector
instance hashableCSSSelector :: Hashable CSSSelector where
  hash (CSSClassSelector s) = hash s

instance showCSSSelector :: Show CSSSelector where
  show (CSSClassSelector s) = "." <> s

newtype CSSText = 
  CSSText String

derive newtype instance eqCSSText :: Eq CSSText
derive newtype instance ordCSSText :: Ord CSSText
derive newtype instance semigroupCSSText :: Semigroup CSSText
derive newtype instance monoidCSSText :: Monoid CSSText
derive newtype instance hashableCSSText :: Hashable CSSText

instance showCSSText :: Show CSSText where
  show (CSSText s) = s

newtype MediaQueryText
  = MediaQueryText String

derive newtype instance eqMediaQueryText :: Eq MediaQueryText
derive newtype instance ordMediaQueryText :: Ord MediaQueryText
derive newtype instance semigroupMediaQueryText :: Semigroup MediaQueryText
derive newtype instance monoidMediaQueryText :: Monoid MediaQueryText

instance showMediaQueryText :: Show MediaQueryText where
  show (MediaQueryText s) = s

data InsertRule
  = InsertRule CSSSelector CSSText

instance showInsertRule :: Show InsertRule where
  show (InsertRule css text) = show css <> " { " <> show text <> " }"

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
