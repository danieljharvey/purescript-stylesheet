module Stylesheet.Types.Stylesheet (Stylesheet(..), addVirtualStylesheet, readVirtualStylesheet, getCSSStylesheet, createBlankStylesheet) where

import Prelude (Unit, bind, mempty, pure, (<>))

import Data.Symbol (class IsSymbol, SProxy(..), reflectSymbol)
import Data.Traversable (traverse_)
import Effect (Effect)
import Effect.Ref (Ref, modify, new, read)
import CSSOM.Main (CSSStyleSheet)

import Stylesheet.Internal.DomActions (createStyleTag, insertRecursive)
import Stylesheet.Types.Primitives (StylesheetId(..))
import Stylesheet.Types.VirtualStylesheet

data Stylesheet (p :: Symbol)
  = Stylesheet 
      CSSStyleSheet 
      (Ref (VirtualStylesheet p))

readVirtualStylesheet 
  :: forall p
   . Stylesheet p
  -> Effect (VirtualStylesheet p)
readVirtualStylesheet (Stylesheet _ vsRef) 
  = read vsRef

addVirtualStylesheet
  :: forall p
   . Stylesheet p
  -> VirtualStylesheet p
  -> Effect Unit
addVirtualStylesheet (Stylesheet cssSheet vsRef) vSheet = do
  oldSheet <- read vsRef
  newSheet <- modify (\oldSheet' -> oldSheet' <> vSheet) vsRef
  -- update actual thing  
  traverse_ (insertRecursive cssSheet) (diff newSheet oldSheet)  

getCSSStylesheet
  :: forall p
   . Stylesheet p
  -> CSSStyleSheet
getCSSStylesheet (Stylesheet s _) = s

-- | Create a StyleSheet in the DOM along with an empty
-- | VirtualStylesheet to record it's contents
createBlankStylesheet 
  :: forall p
   . IsSymbol p
  => Effect (Stylesheet p)
createBlankStylesheet = do
  let sId = StylesheetId (reflectSymbol (SProxy :: SProxy p))
  domStylesheet <- createStyleTag sId
  newVirtualStylesheet <- new mempty
  pure (Stylesheet domStylesheet newVirtualStylesheet)
