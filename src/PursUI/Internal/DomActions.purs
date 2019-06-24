module PursUI.Internal.DomActions where

import Prelude (Unit)
import Effect (Effect)
import Effect.Uncurried (runEffectFn1, runEffectFn3)
import PursUI.Internal.Types
import PursUI.Internal.CSSOM (CSSStyleSheet, createStyleTagJS, putStyleJS)

putStyle 
  :: CSSStyleSheet
  -> CSSClassName
  -> CSSText
  -> Effect Unit
putStyle stylesheet (CSSClassName _className) (CSSText text)
  = runEffectFn3 putStyleJS stylesheet _className text

---

createStyleTag
  :: StyleSheetId
  -> Effect CSSStyleSheet
createStyleTag (StyleSheetId s)
  = runEffectFn1 createStyleTagJS s

