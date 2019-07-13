module PursUI.Tools where

import Prelude (Unit, bind, discard, pure, show, unit, (<>), (==))
import Data.Maybe (Maybe(..))
import Data.Traversable (find, traverse, traverse_)
import Effect (Effect)

import PursUI.DOM.EditRules (CSSMediaRule, CSSRuleList, CSSStyleRule, CSSStyleSheet, IndexedRule) 
import PursUI.DomActions (deleteMediaRuleRule, deleteRule, getFilteredRuleList, getMediaRuleMediaText, getMediaRuleRuleList, getStyleRuleDeclarationText, getStyleRuleSelectorText, getStyleSheetRuleList, insertMediaRuleRule, insertRule)
import PursUI.Types.Primitives

-- this takes all the raw calls and builds up a few actually useful functions
-- for CSSOM manipulation

findRuleBySelector
  :: CSSRuleList
  -> CSSSelector
  -> Effect (Maybe (UnpackedRule CSSStyleRule))
findRuleBySelector ruleList selector = do
  unpacked <- getUnpackedStyleRules ruleList    
  pure (find (\s -> s.selector == selector) unpacked)

-- | Insert new rule into stylesheet, deleting old one if name matches
insertRuleIntoStyleSheet
  :: CSSStyleSheet
  -> InsertRule
  -> Effect Unit
insertRuleIntoStyleSheet stylesheet insertItem@(InsertRule selector text) = do
  ruleList <- getStyleSheetRuleList stylesheet
  found <- findRuleBySelector ruleList selector
  case found of
    Just rule -> deleteRule stylesheet rule.id
    _         -> pure unit
  insertRule stylesheet (show insertItem)
  pure unit

-- | Insert new rule into stylesheet, deleting old one if name matches
insertRuleIntoMediaRule
  :: CSSMediaRule
  -> InsertRule
  -> Effect Unit
insertRuleIntoMediaRule mediaRule insertItem@(InsertRule selector text) = do
  ruleList <- getMediaRuleRuleList mediaRule
  found <- findRuleBySelector ruleList selector
  case found of
    Just rule -> deleteMediaRuleRule mediaRule rule.id
    _         -> pure unit
  insertMediaRuleRule mediaRule (show insertItem)
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


createAndReturnStyleSheetMediaQuery
  :: CSSStyleSheet
  -> MediaQueryText
  -> Effect (Maybe (UnpackedMediaRule CSSMediaRule))
createAndReturnStyleSheetMediaQuery stylesheet query = do
  ruleList <- getStyleSheetRuleList stylesheet
  alreadyExists <- findMediaQueryByQuery ruleList query
  case alreadyExists of
    Just _ -> pure alreadyExists
    _      -> do
        insertRule stylesheet ("@media " <> show query <> " { } ")
        findMediaQueryByQuery ruleList query

createAndReturnNestedMediaQuery
  :: CSSMediaRule
  -> MediaQueryText
  -> Effect (Maybe (UnpackedMediaRule CSSMediaRule))
createAndReturnNestedMediaQuery mediaRule query = do
  ruleList <- getMediaRuleRuleList mediaRule
  alreadyExists <- findMediaQueryByQuery ruleList query
  case alreadyExists of
    Just _ -> pure alreadyExists
    _      -> do
        insertMediaRuleRule mediaRule ("@media " <> show query <> " { }")
        findMediaQueryByQuery ruleList query 
 
insertRecursiveIntoStyleSheet
  :: CSSStyleSheet
  -> InsertMediaRule
  -> Effect Unit
insertRecursiveIntoStyleSheet stylesheet insertMediaRule = do
  case insertMediaRule of
    InsertMediaQuery query items -> do
        mediaQuery <- createAndReturnStyleSheetMediaQuery stylesheet query
        case mediaQuery of
             Just found -> traverse_ (insertRecursiveIntoMediaQuery found.item) items
             _          -> pure unit

    InsertStyleRule item         
      -> insertRuleIntoStyleSheet stylesheet item

insertRecursiveIntoMediaQuery
  :: CSSMediaRule
  -> InsertMediaRule
  -> Effect Unit
insertRecursiveIntoMediaQuery mediaRule insertMediaRule = do
  case insertMediaRule of
    InsertMediaQuery query items -> do
        mediaQuery <- createAndReturnNestedMediaQuery mediaRule query
        case mediaQuery of
             Just found -> traverse_ (insertRecursiveIntoMediaQuery found.item) items
             _          -> pure unit

    InsertStyleRule item         
      -> insertRuleIntoMediaRule mediaRule item
