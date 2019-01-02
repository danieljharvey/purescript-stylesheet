module CSSom where

import Effect (Effect)
import Data.List
import Prelude (Unit, pure, ($), bind, discard, map, const, unit)
import CSDom (fromName, updateFromStyleRuleList, getUpdatedFromDom)
import ChangeStyle (CSSStyleSheet, putStyle, createStyleTag)
import CSSTypes (CsDom, CsSom, StyleRule(..), StyleSheetId)

putStyleEff :: CSSStyleSheet -> StyleRule -> Effect Unit
putStyleEff st (StyleRule cl tx) = pure $ putStyle st cl tx

putStylesEff :: CSSStyleSheet -> List StyleRule -> Effect Unit
putStylesEff st as = pure $ const unit $ map (putStyleEff st) as

createStyleTagEff :: StyleSheetId -> Effect CSSStyleSheet
createStyleTagEff str = pure $ createStyleTag str

createBlankStyleSheet :: StyleSheetId -> Effect CsSom
createBlankStyleSheet sId = do
  style <- createStyleTagEff sId
  pure {
    styleSheet: style,
    csDom: fromName sId
  }

updateCsDom :: CsSom -> CsDom -> CsSom
updateCsDom som dom = som { csDom = dom }

addStyleEff :: CsSom -> List StyleRule -> Effect CsSom
addStyleEff csSom rules = do
    let oldDom = csSom.csDom
    let newCsDom = updateFromStyleRuleList oldDom rules
    let changes = getUpdatedFromDom oldDom newCsDom
    putStylesEff csSom.styleSheet changes
    pure $ updateCsDom csSom newCsDom
