module Stylesheet.Types.StyleRuleSet where

import Prelude (class Eq, class Monoid, class Semigroup, class Show, show, ($), (&&), (<<<), (<>), (==))
 
import Data.Hashable (class Hashable, hash)
import Stylesheet.Types.Primitives

-- output
-- friendly format for putting into cssom

-- these are split out so when we filter one kind out we can represent the
-- separate ones on the type level
data RuleType
  = ClassType ClassRule
  | MediaType MediaRule

instance showRuleType :: Show RuleType where
  show (ClassType rule) = "ClassType: " <> show rule
  show (MediaType rule) = "MediaType: " <> show rule

instance eqRuleType :: Eq RuleType where
  eq (ClassType a) (ClassType b) = a == b
  eq (MediaType a) (MediaType b) = a == b
  eq _ _ = false

newtype ClassRule
  = ClassRule CSSText

derive newtype instance eqClassRule        :: Eq ClassRule
derive newtype instance showClassRule      :: Show ClassRule
derive newtype instance semigroupClassRule :: Semigroup ClassRule
derive newtype instance monoidClassRule    :: Monoid ClassRule

data MediaRule 
  = MediaRule MediaQueryText (Array RuleType)

instance eqMediaRule :: Eq MediaRule where
  eq (MediaRule m as) (MediaRule n bs) = m == n && as == bs

instance showMediaRule :: Show MediaRule where
  show (MediaRule query rules) 
    = "MediaRule: " <> show query <> ", " <> show rules

newtype StyleRuleSet
  = StyleRuleSet (Array RuleType)

derive newtype instance showStyleRuleSet      :: Show StyleRuleSet
derive newtype instance eqStyleRuleSet        :: Eq StyleRuleSet
derive newtype instance semigroupStyleRuleSet :: Semigroup StyleRuleSet
derive newtype instance monoidStyleRuleSet    :: Monoid StyleRuleSet

instance hashableStyleRuleSet :: Hashable StyleRuleSet where
  hash = (hash <<< show)

wrapInRuleSet :: Array RuleType -> StyleRuleSet
wrapInRuleSet = StyleRuleSet

classRule :: CSSText -> RuleType
classRule = ClassType <<< ClassRule

mediaRule :: MediaQueryText -> Array RuleType -> RuleType
mediaRule queryStr subStyles
  = MediaType $ MediaRule queryStr subStyles


