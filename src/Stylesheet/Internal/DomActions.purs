module Stylesheet.Internal.DomActions where

import Prelude (Unit, bind, discard, pure, show, unit, (<$>), (<>), (==))
import Data.Maybe (Maybe(..))
import Data.Traversable (find, traverse, traverse_)
import Effect (Effect)
import Effect.Uncurried (runEffectFn1)
import Stylesheet.Types.Primitives 
import CSSOM.Main (class HasRuleList, CSSMediaRule, CSSRuleList, CSSRules, CSSStyleRule, CSSStyleSheet, IndexedRule, createStyleTagJS, deleteRule', getFilteredRuleListJS, getMediaRuleMediaTextJS, getRuleList', getStyleRuleDeclarationTextJS, getStyleRuleSelectorTextJS, insertRule')

-- this takes all the raw calls and builds up a few actually useful functions
-- for CSSOM manipulation

createStyleTag
  :: StylesheetId
  -> Effect CSSStyleSheet
createStyleTag (StylesheetId s)
  = runEffectFn1 createStyleTagJS s

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
  = CSSClassSelector <$> runEffectFn1 getStyleRuleSelectorTextJS a

-- | Get the Style Declaration of a CSSStyleRule
getStyleRuleDeclarationText
  :: CSSStyleRule 
  -> Effect CSSText
getStyleRuleDeclarationText a
  = CSSText <$> runEffectFn1 getStyleRuleDeclarationTextJS a

-- | Get the rule from the Media Rule
getMediaRuleMediaText
  :: CSSMediaRule
  -> Effect MediaQueryText
getMediaRuleMediaText a
  = MediaQueryText <$> runEffectFn1 getMediaRuleMediaTextJS a

findRuleBySelector
  :: CSSRuleList
  -> CSSSelector
  -> Effect (Maybe (UnpackedRule CSSStyleRule))
findRuleBySelector ruleList selector = do
  unpacked <- getUnpackedStyleRules ruleList    
  pure (find (\s -> s.selector == selector) unpacked)

-- | Insert new rule into stylesheet, deleting old one if name matches
insertRule
  :: forall a
   . HasRuleList a
  => a
  -> InsertRule
  -> Effect Unit
insertRule parent insertItem@(InsertRule selector text) = do
  ruleList <- getRuleList' parent
  found <- findRuleBySelector ruleList selector
  case found of
    Just rule -> deleteRule' parent rule.id
    _         -> pure unit
  insertRule' parent (show insertItem)
  pure unit

-- | Gets style rules for a rule list and fetches basic data about them
getUnpackedStyleRules
  :: CSSRuleList
  -> Effect (Array (UnpackedRule CSSStyleRule))
getUnpackedStyleRules ruleList = do
  rules <- getFilteredRuleList ruleList
  traverse unpackRule rules.styleRules

-- | This takes an item and returns the selector and declaration text
-- | Useful for diffing etc
unpackRule 
  :: IndexedRule CSSStyleRule 
  -> Effect (UnpackedRule CSSStyleRule)
unpackRule styleRule = do
  ruleText <- getStyleRuleDeclarationText styleRule.item
  selector <- getStyleRuleSelectorText styleRule.item
  pure { id: styleRule.id
       , item: styleRule.item
       , selector
       , ruleText
       }

getUnpackedMediaRules
  :: CSSRuleList
  -> Effect (Array (UnpackedMediaRule CSSMediaRule))
getUnpackedMediaRules ruleList = do
  rules <- getFilteredRuleList ruleList
  traverse unpackMediaRule rules.mediaRules

unpackMediaRule
  :: IndexedRule CSSMediaRule
  -> Effect (UnpackedMediaRule CSSMediaRule)
unpackMediaRule mediaRule = do
  query <- getMediaRuleMediaText mediaRule.item
  pure { id: mediaRule.id
       , item: mediaRule.item
       , query
       } 

findMediaQueryByQuery
  :: CSSRuleList
  -> MediaQueryText
  -> Effect (Maybe (UnpackedMediaRule CSSMediaRule))
findMediaQueryByQuery ruleList query = do
  unpacked <- getUnpackedMediaRules ruleList    
  pure (find (\s -> s.query == query) unpacked)

createAndReturnCSSMediaRule
  :: forall a
   . HasRuleList a
  => a
  -> MediaQueryText
  -> Effect (Maybe (UnpackedMediaRule CSSMediaRule))
createAndReturnCSSMediaRule parent query = do
  ruleList <- getRuleList' parent
  alreadyExists <- findMediaQueryByQuery ruleList query
  case alreadyExists of
    Just _ -> pure alreadyExists
    _      -> do
        insertRule' parent ("@media " <> show query <> " { } ")
        findMediaQueryByQuery ruleList query
 
insertRecursive
  :: forall a
   . HasRuleList a
  => a
  -> InsertMediaRule
  -> Effect Unit
insertRecursive parent insertMediaRule = do
  case insertMediaRule of
    InsertMediaQuery query items -> do
        mediaQuery <- createAndReturnCSSMediaRule parent query
        case mediaQuery of
             Just found -> traverse_ (insertRecursive found.item) items
             _          -> pure unit

    InsertStyleRule item         
      -> insertRule parent item
