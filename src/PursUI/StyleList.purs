module PursUI.StyleList where

import Prelude (flip, (/=))
import Data.Map as Map
import Data.Maybe (Maybe(..))
import Data.List as List
import Data.Foldable

import PursUI.Internal.Types

-- this module stores and retrieves out set of styles for diffing and sending
-- to the CSS dom

rulesToList :: CssRules -> List.List StyleRule
rulesToList cssRules = List.zipWith StyleRule keys values where
  keys = List.fromFoldable (Map.keys cssRules)
  values = Map.values cssRules

getRules :: VirtualStyleSheet -> List.List StyleRule
getRules csDom = rulesToList csDom.cssRules

addRule :: VirtualStyleSheet -> StyleRule -> VirtualStyleSheet
addRule csDom (StyleRule cls txt) = csDom { cssRules = Map.insert cls txt rules }
    where rules = csDom.cssRules

fromName :: StyleSheetId -> VirtualStyleSheet
fromName name 
  = { virtualStyleSheetId : name
    , cssRules : Map.empty
    }

fromStyleRuleList :: StyleSheetId -> List.List StyleRule -> VirtualStyleSheet
fromStyleRuleList name = updateFromStyleRuleList (fromName name)

updateFromStyleRuleList :: VirtualStyleSheet -> List.List StyleRule -> VirtualStyleSheet
updateFromStyleRuleList csDom list = foldr (flip addRule) csDom list

getUpdated :: CssRules -> CssRules -> CssRules
getUpdated old new = Map.filterWithKey filterFunc new where
  filterFunc k v = case Map.lookup k old of
                Just val -> val /= v
                Nothing -> true

getUpdatedFromDom :: VirtualStyleSheet -> VirtualStyleSheet -> List.List StyleRule
getUpdatedFromDom oldDom newDom = rulesToList updates where
  updates = getUpdated oldDom.cssRules newDom.cssRules
