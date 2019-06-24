module PursUI.StyleList where

import Prelude (flip, mempty, (/=))
import Data.HashMap as HM
import Data.Maybe (Maybe(..))
import Data.List as List
import Data.Foldable (foldr)

import PursUI.Internal.Types

-- this module stores and retrieves out set of styles for diffing and sending
-- to the CSS dom

rulesToList :: CssRules -> List.List StyleRule
rulesToList cssRules 
  = List.fromFoldable (HM.toArrayBy ClassRule cssRules)

getRules :: VirtualStyleSheet -> List.List StyleRule
getRules csDom = rulesToList csDom.cssRules

addRule :: VirtualStyleSheet -> StyleRule -> VirtualStyleSheet
addRule csDom (ClassRule cls txt) = csDom { cssRules = HM.insert cls txt rules }
    where rules = csDom.cssRules

fromName 
  :: StyleSheetId 
  -> VirtualStyleSheet
fromName name 
  = { virtualStyleSheetId : name
    , cssRules : mempty
    }

fromStyleRuleList :: StyleSheetId -> List.List StyleRule -> VirtualStyleSheet
fromStyleRuleList name = updateFromStyleRuleList (fromName name)

updateFromStyleRuleList :: VirtualStyleSheet -> List.List StyleRule -> VirtualStyleSheet
updateFromStyleRuleList csDom list = foldr (flip addRule) csDom list

getUpdated :: CssRules -> CssRules -> CssRules
getUpdated old new = HM.filterWithKey filterFunc new where
  filterFunc k v = case HM.lookup k old of
                Just val -> val /= v
                Nothing -> true

getUpdatedFromDom :: VirtualStyleSheet -> VirtualStyleSheet -> List.List StyleRule
getUpdatedFromDom oldDom newDom = rulesToList updates where
  updates = getUpdated oldDom.cssRules newDom.cssRules
