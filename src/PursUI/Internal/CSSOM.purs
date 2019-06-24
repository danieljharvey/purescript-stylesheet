module PursUI.Internal.CSSOM where

import Prelude (Unit)
import Effect.Uncurried

foreign import data CSSStyleSheet :: Type

---

foreign import putStyleJS 
  :: EffectFn3 CSSStyleSheet String String Unit

---

foreign import createStyleTagJS 
  :: EffectFn1 String CSSStyleSheet


