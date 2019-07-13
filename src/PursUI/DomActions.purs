module PursUI.DomActions where

import Prelude (Unit, (<$>))
import Effect (Effect)
import Effect.Uncurried (runEffectFn1, runEffectFn2)
import PursUI.Types.Primitives
import PursUI.DOM.EditRules (CSSMediaRule, CSSRuleList, CSSRules, CSSStyleRule, CSSStyleSheet, deleteRuleJS, getFilteredRuleListJS, getMediaRuleMediaTextJS, getMediaRuleRuleListJS, getStyleRuleDeclarationTextJS, getStyleRuleSelectorTextJS, getStyleSheetRuleListJS, insertMediaRuleRuleJS, insertRuleJS)
import PursUI.DOM.CreateStyleSheet (createStyleTagJS)

{-
putStyle 
  :: CSSStyleSheet
  -> CSSClassName
  -> CSSText
  -> Effect Unit
putStyle stylesheet (CSSClassName _className) (CSSText text)
  = runEffectFn3 putStyleJS stylesheet _className text

-}

---

createStyleTag
  :: StyleSheetId
  -> Effect CSSStyleSheet
createStyleTag (StyleSheetId s)
  = runEffectFn1 createStyleTagJS s

getStyleSheetRuleList
  :: CSSStyleSheet
  -> Effect CSSRuleList
getStyleSheetRuleList
  = runEffectFn1 getStyleSheetRuleListJS

-- | Insert a style rule into a stylesheet via string
insertRule 
  :: CSSStyleSheet 
  -> String
  -> Effect Unit
insertRule = runEffectFn2 insertRuleJS

-- | Insert a style rule into a media rule via string
insertMediaRuleRule
  :: CSSMediaRule
  -> String
  -> Effect Unit
insertMediaRuleRule = runEffectFn2 insertMediaRuleRuleJS

--- | Delete a style rule from a stylesheet by its Id
deleteRule
  :: CSSStyleSheet 
  -> Int
  -> Effect Unit
deleteRule = runEffectFn2 deleteRuleJS

-- | Get all the rules of a stylesheet, split by type
getFilteredRuleList
  :: CSSRuleList 
  -> Effect CSSRules
getFilteredRuleList = runEffectFn1 getFilteredRuleListJS

-- | Get the selector text of a CSSStyleRule
getStyleRuleSelectorText
  :: CSSStyleRule 
  -> Effect CSSSelector
getStyleRuleSelectorText a
  = CSSSelector <$> runEffectFn1 getStyleRuleSelectorTextJS a

-- | Get the Style Declaration of a CSSStyleRule
getStyleRuleDeclarationText
  :: CSSStyleRule 
  -> Effect CSSText
getStyleRuleDeclarationText a
  = CSSText <$> runEffectFn1 getStyleRuleDeclarationTextJS a

getMediaRuleRuleList
  :: CSSMediaRule
  -> Effect CSSRuleList
getMediaRuleRuleList = runEffectFn1 getMediaRuleRuleListJS

-- | Get the rule from the Media Rule
getMediaRuleMediaText
  :: CSSMediaRule
  -> Effect MediaQueryText
getMediaRuleMediaText a
  = MediaQueryText <$> runEffectFn1 getMediaRuleMediaTextJS a

