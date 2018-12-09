module CSDom where

import Prelude
import CSSom (CSSClassName, CSSText, StyleRule(..), StyleSheetId)
import Data.Map as Map
import Data.List as List
import Helpers (setToList)
import Data.Foldable (foldr)

type CssRules = Map.Map CSSClassName CSSText

type CsDom = { styleSheetId :: StyleSheetId
             , cssRules :: Map.Map CSSClassName CSSText
}

initialCsDom :: CsDom
initialCsDom = fromName ""

getRules :: CsDom -> List.List StyleRule
getRules csDom = List.zipWith StyleRule keys values where
  keys = setToList (Map.keys csDom.cssRules) 
  values = Map.values csDom.cssRules

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