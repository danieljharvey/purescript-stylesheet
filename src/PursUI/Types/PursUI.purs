module PursUI.Types.PursUI (PursUI, addVirtualStyleSheet, readVirtualStyleSheet, getCSSStyleSheet, createBlankStyleSheet) where

import Prelude (Unit, bind, mempty, pure, (<>))

import Data.Symbol (class IsSymbol, SProxy(..), reflectSymbol)
import Data.Traversable (traverse_)
import Effect (Effect)
import Effect.Ref (Ref, modify, new, read)
import CSSOM.Main (CSSStyleSheet)

import PursUI.DomActions (createStyleTag, insertRecursive)
import PursUI.Types.Primitives (StyleSheetId(..))
import PursUI.Types.VirtualStyleSheet

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
addVirtualStyleSheet (PursUI cssSheet vsRef) vSheet = do
  oldSheet <- read vsRef
  newSheet <- modify (\oldSheet' -> oldSheet' <> vSheet) vsRef
  -- update actual thing  
  traverse_ (insertRecursive cssSheet) (diff newSheet oldSheet)  

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
