module PursUI.Types.VirtualStyleSheet where

import Prelude (class Monoid, class Semigroup, mempty, (<>))
import PursUI.Types.Primitives
import PursUI.StyleLens (getClasses)
import Data.HashMap as HM
import Data.Symbol (class IsSymbol, SProxy(..), reflectSymbol)

-- our virtual stylesheet is our idea of the stylesheet
-- we add to this
-- and then it is differed so the real one reflects it
data VirtualStyleSheet (p :: Symbol)
  = MkVirtualStyleSheet (HM.HashMap (Array CSSSelector) InsertMediaRule)

instance semigroupVirtualStyleSheet :: Semigroup (VirtualStyleSheet p) where
  append (MkVirtualStyleSheet a) (MkVirtualStyleSheet b)
    = MkVirtualStyleSheet (a <> b)

instance monoidVirtualStyleSheet :: Monoid (VirtualStyleSheet p) where
  mempty = MkVirtualStyleSheet mempty

fromItem 
  :: forall p
   . InsertMediaRule 
  -> VirtualStyleSheet p
fromItem rule 
  = MkVirtualStyleSheet (HM.singleton key rule)
  where
    key
      = getClasses rule 

-- | Takes old one and new one and return the changes
diff
  :: forall p
   . VirtualStyleSheet p
  -> VirtualStyleSheet p
  -> Array (InsertMediaRule)
diff (MkVirtualStyleSheet new) (MkVirtualStyleSheet old) 
  = HM.values (HM.difference new old)

---

getStyleSheetId
  :: forall s
   . IsSymbol s
  => VirtualStyleSheet s
  -> StyleSheetId
getStyleSheetId _
  = StyleSheetId (reflectSymbol (SProxy :: SProxy s))

---
