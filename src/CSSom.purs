module CSSom where

import Effect (Effect)
import Data.List
import Prelude (Unit, pure, ($), bind, discard, map, const, unit, show)
import CSDom (fromName, updateFromStyleRuleList, getUpdatedFromDom)
import ChangeStyle (CSSStyleSheet, putStyle, createStyleTag)
import CSSTypes (CsDom, CsSom, StyleRule(..), StyleSheetId)
import Effect.Ref (new, write, read)
import Effect.Console (log)

putStyleEff :: CSSStyleSheet -> StyleRule -> Effect Unit
putStyleEff st (StyleRule cl tx) = pure $ putStyle st cl tx

putStylesEff :: CSSStyleSheet -> List StyleRule -> Effect Unit
putStylesEff st as = pure $ const unit $ map (putStyleEff st) as

createStyleTagEff :: StyleSheetId -> Effect CSSStyleSheet
createStyleTagEff str = pure $ createStyleTag str

createBlankStyleSheet :: StyleSheetId -> Effect CsSom
createBlankStyleSheet sId = do
  style <- createStyleTagEff sId
  newCsDom <- new $ fromName sId
  pure {
    styleSheet: style,
    csDom: newCsDom
  }

addStyleEff :: CsSom -> List StyleRule -> Effect Unit
addStyleEff csSom rules = do
    oldDom <- read csSom.csDom
    let newCsDom = updateFromStyleRuleList oldDom rules
    let changes = getUpdatedFromDom oldDom newCsDom
    putStylesEff csSom.styleSheet changes
    write newCsDom csSom.csDom
    pure unit
