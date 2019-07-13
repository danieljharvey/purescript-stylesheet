module PursUI.DOM.EditRules where

import Prelude (Unit)
import Effect.Uncurried

foreign import data CSSStyleSheet :: Type
foreign import data CSSMediaRule  :: Type
foreign import data CSSStyleRule  :: Type
foreign import data CSSRuleList   :: Type

type IndexedRule a
  = { id   :: Int
    , item :: a
    }

type CSSRules 
  = { styleRules :: Array (IndexedRule CSSStyleRule)
    , mediaRules :: Array (IndexedRule CSSMediaRule)
    } 

foreign import getStyleSheetRuleListJS
  :: EffectFn1 CSSStyleSheet CSSRuleList 

-- | Insert a style rule into a stylesheet via string
foreign import insertRuleJS 
  :: EffectFn2 CSSStyleSheet String Unit

--- | Delete a style rule from a stylesheet by its Id
foreign import deleteRuleJS
  :: EffectFn2 CSSStyleSheet Int Unit

-- | Get all the rules of a stylesheet, split by type
foreign import getFilteredRuleListJS 
  :: EffectFn1 CSSRuleList CSSRules

-- | Insert a style that applies to a media rule only
foreign import insertMediaRuleRuleJS
  :: EffectFn2 CSSMediaRule String Unit

-- | Delete a style that applies to a media rule only
foreign import deleteMediaRuleRuleJS
  :: EffectFn2 CSSMediaRule Int Unit

-- | Get the selector text of a CSSStyleRule
foreign import getStyleRuleSelectorTextJS
  :: EffectFn1 CSSStyleRule String

-- | Get the Style Declaration of a CSSStyleRule
foreign import getStyleRuleDeclarationTextJS
  :: EffectFn1 CSSStyleRule String

foreign import getMediaRuleRuleListJS
  :: EffectFn1 CSSMediaRule CSSRuleList

-- | Get the rule from the Media Rule
foreign import getMediaRuleMediaTextJS
  :: EffectFn1 CSSMediaRule String
