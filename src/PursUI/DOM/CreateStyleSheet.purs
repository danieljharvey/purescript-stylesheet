module PursUI.DOM.CreateStyleSheet where

import Effect.Uncurried (EffectFn1)
import PursUI.DOM.EditRules (CSSStyleSheet)

foreign import createStyleTagJS 
  :: EffectFn1 String CSSStyleSheet


