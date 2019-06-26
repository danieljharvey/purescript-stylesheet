module PursUI.Types.PursUI (PursUI, readVirtualStyleSheet, getCSSStyleSheet, createBlankStyleSheet) where

import Prelude

import Data.Symbol (class IsSymbol, SProxy(..), reflectSymbol)
import Effect (Effect)
import Effect.Ref (Ref, modify_, new, read)
import PursUI.DOM.EditRules (CSSStyleSheet)
import PursUI.DomActions (createStyleTag)
import PursUI.Types.Primitives (StyleSheetId(..))
import PursUI.Types.VirtualStyleSheet (VirtualStyleSheet)

data PursUI (p :: Symbol)
  = PursUI 
      CSSStyleSheet 
      (Ref (VirtualStyleSheet p))

readVirtualStyleSheet 
  :: forall p
   . PursUI p
  -> Effect (VirtualStyleSheet p)
readVirtualStyleSheet (PursUI _ vsRef) 
  = read vsRef

addVirtualStyleSheet
  :: forall p
   . PursUI p
  -> VirtualStyleSheet p
  -> Effect Unit
addVirtualStyleSheet (PursUI cssSheet vsRef) vSheet =
  modify_ (\oldSheet -> oldSheet <> vSheet) vsRef

getCSSStyleSheet
  :: forall p
   . PursUI p
  -> CSSStyleSheet
getCSSStyleSheet (PursUI s _) = s

-- | Create a StyleSheet in the DOM along with an empty
-- | VirtualStylesheet to record it's contents
createBlankStyleSheet 
  :: forall p
   . IsSymbol p
  => Effect (PursUI p)
createBlankStyleSheet = do
  let sId = StyleSheetId (reflectSymbol (SProxy :: SProxy p))
  domStyleSheet <- createStyleTag sId
  newVirtualStyleSheet <- new mempty
  pure (PursUI domStyleSheet newVirtualStyleSheet)
