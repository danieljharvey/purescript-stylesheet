module PursUI.Create where

import Prelude
import Effect (Effect)
import Effect.Ref (new, write, read)
import Data.List (List)
import PursUI.StyleList (fromName, updateFromStyleRuleList, getUpdatedFromDom)
import PursUI.Internal.CSSOM (CSSStyleSheet, putStyle, createStyleTag)
import PursUI.Internal.Types (CsSom, StyleRule(..), StyleSheetId)

putStyleEff :: CSSStyleSheet -> StyleRule -> Effect Unit
putStyleEff st (StyleRule cl tx) = pure $ putStyle st cl tx

putStylesEff :: CSSStyleSheet -> List StyleRule -> Effect Unit
putStylesEff st as = pure $ const unit $ map (putStyleEff st) as

createStyleTagEff :: StyleSheetId -> Effect CSSStyleSheet
createStyleTagEff str = pure $ createStyleTag str

createBlankStyleSheet :: StyleSheetId -> Effect CsSom
createBlankStyleSheet sId = do
  style <- createStyleTagEff sId
  newVirtualStyleSheet <- new $ fromName sId
  pure {
    styleSheet: style,
    csDom: newVirtualStyleSheet
  }

addStyleEff :: CsSom -> List StyleRule -> Effect Unit
addStyleEff csSom rules = do
    oldDom <- read csSom.csDom
    let newVirtualStyleSheet = updateFromStyleRuleList oldDom rules
    let changes = getUpdatedFromDom oldDom newVirtualStyleSheet
    putStylesEff csSom.styleSheet changes
    write newVirtualStyleSheet csSom.csDom
    pure unit
