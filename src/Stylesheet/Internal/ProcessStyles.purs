module Stylesheet.Internal.ProcessStyles where

import Prelude (flap, map, pure, show, ($), (<<<), (<>))
import Stylesheet.Types.CSSRuleSet (CSSRule(..), CSSRuleSet(..))
import Stylesheet.Types.StyleRuleSet
import Stylesheet.Types.Primitives (CSSSelector(..), CSSText, InsertMediaRule(..), InsertRule(..))
import Data.Array (concatMap)
import Data.Foldable (foldr)
import Data.Hashable (hash)

processStyle
  :: forall props
   . CSSRuleSet props
  -> props
  -> StyleRuleSet
processStyle ruleSet props
  = wrapInRuleSet (process ruleSet)
  where
    process :: CSSRuleSet props -> Array RuleType
    process (CSSRuleSet styles')
     = flap (map renderer styles') props
    
    renderer style props'
      = case style of
          Const string    -> classRule string
          Lens f          -> classRule (f props')
          MediaQuery s as -> mediaRule s (process as)

-- | This creates a unique hash of the CSS that we'll use to make the classname
createHashedInsertRule :: CSSText -> InsertRule
createHashedInsertRule css
  = InsertRule selector css
  where
    appendPrefix s
      = "ps-" <> s

    selector
      = CSSClassSelector <<< appendPrefix <<< show <<< hash $ css

-- | This commits the rendered StyleRuleSet into InsertMediaRules that we can
-- | store and apply to the CSSOM
keep :: StyleRuleSet -> Array InsertMediaRule
keep (StyleRuleSet rules)
  = foldr fold [] rules
  where
    fold rule as
      = as <> case rule of
          ClassType (ClassRule a) 
            -> pure 
           <<< InsertStyleRule 
           <<< createHashedInsertRule
             $ a
          MediaType (MediaRule query rules')
            -> pure (InsertMediaQuery query (keep (StyleRuleSet rules')))

-- | Get the generated CSS classes from the CSS. These are generated from
-- | hashes of the content
getClasses :: InsertMediaRule -> Array CSSSelector
getClasses (InsertStyleRule (InsertRule selector _))
  = pure selector 
getClasses (InsertMediaQuery _ as) 
  = concatMap getClasses as

---
