module PursUI.Internal.CreateStyleSheet where

import Effect.Uncurried (EffectFn1)
import PursUI.Internal.CSSOM (CSSStyleSheet)

foreign import createStyleTagJS 
  :: EffectFn1 String CSSStyleSheet


