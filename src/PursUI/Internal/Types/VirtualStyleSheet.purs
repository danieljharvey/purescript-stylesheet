module PursUI.Internal.Types.VirtualStyleSheet where

import Prelude (class Monoid, class Semigroup, mempty, (<>))
import PursUI.Internal.Types
import Data.Array as Array
import Data.Foldable
import Data.HashMap as HM
import Data.Symbol (class IsSymbol, SProxy(..), reflectSymbol)

-- our virtual stylesheet is our idea of the stylesheet
-- we add to this
-- and then it is differed so the real one reflects it
data VirtualStyleSheet (p :: Symbol)
  = MkVirtualStyleSheet (HM.HashMap CSSClassName CSSText)

instance semigroupVirtualStyleSheet :: Semigroup (VirtualStyleSheet p) where
  append (MkVirtualStyleSheet a) (MkVirtualStyleSheet b)
    = MkVirtualStyleSheet (a <> b)

instance monoidVirtualStyleSheet :: Monoid (VirtualStyleSheet p) where
  mempty = MkVirtualStyleSheet mempty

---

getStyleSheetId
  :: forall s
   . IsSymbol s
  => VirtualStyleSheet s
  -> StyleSheetId
getStyleSheetId _
  = StyleSheetId (reflectSymbol (SProxy :: SProxy s))

---

getRules
  :: forall s
   . VirtualStyleSheet s
  -> Array StyleRule
getRules (MkVirtualStyleSheet rules) 
  = Array.fromFoldable (HM.toArrayBy ClassRule rules)

--- store items in the hashmap

fromStyleRules
  :: forall s t
   . Foldable t
  => t StyleRule
  -> VirtualStyleSheet s
fromStyleRules rules
  = MkVirtualStyleSheet (fromFoldable rules)