module PursUI.Internal.CSSOM where

import Prelude (Unit)

foreign import data CSSStyleSheet :: Type
foreign import putStyle :: CSSStyleSheet -> String -> String -> Unit
foreign import createStyleTag :: String -> CSSStyleSheet
