module Stylesheet.Types.VirtualStylesheet where

import Prelude (class Monoid, class Semigroup, mempty, (<>))
import Stylesheet.Types.Primitives
import Stylesheet.Internal.ProcessStyles (getClasses)
import Data.HashMap as HM
import Data.Symbol (class IsSymbol, SProxy(..), reflectSymbol)

-- our virtual stylesheet is our idea of the stylesheet
-- we add to this
-- and then it is differed so the real one reflects it
data VirtualStylesheet (p :: Symbol)
  = MkVirtualStylesheet (HM.HashMap (Array CSSSelector) InsertMediaRule)

instance semigroupVirtualStylesheet :: Semigroup (VirtualStylesheet p) where
  append (MkVirtualStylesheet a) (MkVirtualStylesheet b)
    = MkVirtualStylesheet (a <> b)

instance monoidVirtualStylesheet :: Monoid (VirtualStylesheet p) where
  mempty = MkVirtualStylesheet mempty

fromItem 
  :: forall p
   . InsertMediaRule 
  -> VirtualStylesheet p
fromItem rule 
  = MkVirtualStylesheet (HM.singleton key rule)
  where
    key
      = getClasses rule 

-- | Takes old one and new one and return the changes
diff
  :: forall p
   . VirtualStylesheet p
  -> VirtualStylesheet p
  -> Array (InsertMediaRule)
diff (MkVirtualStylesheet new) (MkVirtualStylesheet old) 
  = HM.values (HM.difference new old)

---

getStylesheetId
  :: forall s
   . IsSymbol s
  => VirtualStylesheet s
  -> StylesheetId
getStylesheetId _
  = StylesheetId (reflectSymbol (SProxy :: SProxy s))

---
