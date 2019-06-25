module PursUI.Internal.EditRules where

import Prelude (Unit)
import Effect.Uncurried

foreign import data CSSStyleSheet :: Type

---

foreign import insertRuleJS 
  :: EffectFn2 CSSStyleSheet String Unit

---

foreign import deleteRuleJS
  :: EffectFn2 CSSStyleSheet Int Unit

---

foreign import getStylesheetRulesJS 
  :: EffectFn1 CSSStyleSheet (Array String)
