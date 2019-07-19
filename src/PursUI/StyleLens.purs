module PursUI.StyleLens where

import Prelude (flap, map, mempty, pure, show, ($), (<<<), (<>))
import PursUI.Types.CSSRuleSet (CSSRule(..), CSSRuleSet(..))
import PursUI.Types.StyleRuleSet
import PursUI.Types.Primitives (CSSSelector(..), CSSText, InsertMediaRule(..), InsertRule(..))
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

-- for now we'll discard media query ones
-- and just output the basic bullshit

outputClassRule
  :: ClassRule
  -> String
outputClassRule rule
  = ".blah { " <> show rule <> "}"

filterBasicRules :: StyleRuleSet -> Array ClassRule
filterBasicRules (StyleRuleSet rules)
  = foldr fold [] rules
  where
    fold rule as
      = as <> case rule of
                ClassType a -> [a]
                _           -> [] 

renderBasic
  :: forall props
   . CSSRuleSet props
  -> props
  -> String
renderBasic ruleSet props
  = outputClassRule $ foldr (<>) mempty rules
  where
    rules
      = filterBasicRules (processStyle ruleSet props) 

createHashedInsertRule :: CSSText -> InsertRule
createHashedInsertRule css
  = InsertRule selector css
  where
    appendPrefix s
      = "ps" <> s

    selector
      = CSSClassSelector <<< appendPrefix <<< show <<< hash $ css

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

getClasses :: InsertMediaRule -> Array CSSSelector
getClasses (InsertStyleRule (InsertRule selector _))
  = pure selector 
getClasses (InsertMediaQuery _ as) 
  = concatMap getClasses as

{-    

expected:

.hash {
  background-color: black;
  height: 100px;
  width: 100px;
  border: none;
}

@media (max-width: 600px) {
  .hash2 {
    color: red;
  }
}

-}

---
