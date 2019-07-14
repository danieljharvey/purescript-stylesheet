module PursUI.StyleLens where

import Prelude (flap, map, mempty, show, ($), (<>))
import PursUI.Types.CSSRuleSet (CSSRule(..), CSSRuleSet(..))
import PursUI.Types.StyleRuleSet
import Data.Foldable (foldr)

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
