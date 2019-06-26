module PursUI.DomActions where

import Effect (Effect)
import Effect.Uncurried (runEffectFn1)
import PursUI.Types.Primitives
import PursUI.DOM.EditRules (CSSStyleSheet)
import PursUI.DOM.CreateStyleSheet (createStyleTagJS)

{-
putStyle 
  :: CSSStyleSheet
  -> CSSClassName
  -> CSSText
  -> Effect Unit
putStyle stylesheet (CSSClassName _className) (CSSText text)
  = runEffectFn3 putStyleJS stylesheet _className text

-}

---

createStyleTag
  :: StyleSheetId
  -> Effect CSSStyleSheet
createStyleTag (StyleSheetId s)
  = runEffectFn1 createStyleTagJS s

