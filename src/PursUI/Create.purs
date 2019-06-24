module PursUI.Create where

import Prelude (Unit, bind, discard, pure, ($))
import Effect (Effect)
import Effect.Ref (new, write, read)
import Data.Foldable (class Foldable)
import Data.List (List)
import Data.Traversable (traverse_)
import PursUI.StyleList (fromName, updateFromStyleRuleList, getUpdatedFromDom)
import PursUI.Internal.CSSOM (CSSStyleSheet)
import PursUI.Internal.DomActions (createStyleTag, putStyle)
import PursUI.Internal.Types

-- | takes a StyleRule and updates the dom with them
putStyleEff 
  :: CSSStyleSheet 
  -> StyleRule 
  -> Effect Unit
putStyleEff st (ClassRule cl tx) 
  = putStyle st cl tx

-- | Helpers function - takes multiple StyleRules and updates the DOM with them
putStylesEff 
  :: forall t
   . (Foldable t)
  => CSSStyleSheet 
  -> t StyleRule 
  -> Effect Unit
putStylesEff st as 
  = traverse_ (putStyleEff st) as

-- | Create a StyleSheet in the DOM along with an empty
-- | VirtualStylesheet to record it's contents
createBlankStyleSheet 
  :: StyleSheetId 
  -> Effect PursUI
createBlankStyleSheet sId = do
  style <- createStyleTag sId
  newVirtualStyleSheet <- new $ fromName sId
  pure {
    styleSheet: style,
    csDom: newVirtualStyleSheet
  }

-- imperatively add a new style and update the CSSOM with it
addStyleEff 
  :: PursUI 
  -> List StyleRule 
  -> Effect Unit
addStyleEff csSom rules = do
    oldDom <- read csSom.csDom
    let newVirtualStyleSheet = updateFromStyleRuleList oldDom rules
    let changes = getUpdatedFromDom oldDom newVirtualStyleSheet
    putStylesEff csSom.styleSheet changes
    write newVirtualStyleSheet csSom.csDom
