module CSDom where

import Prelude (flip, (/=))
import Data.Map as Map
import Data.Maybe (Maybe(..))
import Data.List as List
import Helpers (setToList)
import Data.Foldable (foldr)

import CSSTypes

initialCsDom :: CsDom
initialCsDom = fromName ""

rulesToList :: CssRules -> List.List StyleRule
rulesToList cssRules = List.zipWith StyleRule keys values where
  keys = setToList (Map.keys cssRules)
  values = Map.values cssRules

getRules :: CsDom -> List.List StyleRule
getRules csDom = rulesToList csDom.cssRules

addRule :: CsDom -> StyleRule -> CsDom
addRule csDom (StyleRule cls txt) = csDom { cssRules = Map.insert cls txt rules }
    where rules = csDom.cssRules

fromName :: StyleSheetId -> CsDom
fromName name = { styleSheetId : name
               , cssRules : Map.empty
               }

fromStyleRuleList :: StyleSheetId -> List.List StyleRule -> CsDom
fromStyleRuleList name = updateFromStyleRuleList (fromName name)

updateFromStyleRuleList :: CsDom -> List.List StyleRule -> CsDom
updateFromStyleRuleList csDom list = foldr (flip addRule) csDom list

getUpdated :: CssRules -> CssRules -> CssRules
getUpdated old new = Map.filterWithKey filterFunc new where
  filterFunc k v = case Map.lookup k old of
                Just val -> val /= v
                Nothing -> true

getUpdatedFromDom :: CsDom -> CsDom -> List.List StyleRule
getUpdatedFromDom oldDom newDom = rulesToList updates where
  updates = getUpdated oldDom.cssRules newDom.cssRules
