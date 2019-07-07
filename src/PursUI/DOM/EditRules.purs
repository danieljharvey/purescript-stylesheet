module PursUI.DOM.EditRules where

import Prelude (Unit)
import Effect.Uncurried

foreign import data CSSStyleSheet :: Type
foreign import data CSSMediaRule  :: Type
foreign import data CSSStyleRule  :: Type

type CSSRuleList 
  = { styleRules :: Array CSSStyleRule
    , mediaRules :: Array CSSMediaRule
    } 



-- | Insert a style rule into a stylesheet via string
foreign import insertRuleJS 
  :: EffectFn2 CSSStyleSheet String Unit

--- | Delete a style rule from a stylesheet by its Id
foreign import deleteRuleJS
  :: EffectFn2 CSSStyleSheet Int Unit

-- | Get all the rules of a stylesheet, split by type
foreign import getStylesheetRulesJS 
  :: EffectFn1 CSSStyleSheet CSSRuleList


-- | Get the selector text of a CSSStyleRule
foreign import getStyleRuleSelectorText
  :: EffectFn1 CSSStyleRule String

-- | Get the Style Declaration of a CSSStyleRule
foreign import getStyleRuleDeclarationText
  :: EffectFn1 CSSStyleRule String

-- | Get the CSSRuleList inside a MediaRule
foreign import getMediaRuleStyleRules
  :: EffectFn1 CSSMediaRule CSSRuleList 

-- | Get the rule from the Media Rule
foreign import getMediaRuleMediaText
  :: EffectFn1 CSSMediaRule String
