module CSSom (putStyleEff, createStyleTagEff, CSSStyleSheet, CSSClassName, CSSText, StyleRule(StyleRule), StyleSheetId) where

import Effect (Effect)
import Prelude (Unit, bind, pure, unit, ($), discard)
import Data.Eq

foreign import data CSSStyleSheet :: Type
foreign import putStyle :: CSSStyleSheet -> String -> String -> Unit
foreign import createStyleTag :: String -> CSSStyleSheet

type StyleSheetId = String
type CSSClassName = String
type CSSText = String

data StyleRule = StyleRule CSSClassName CSSText
derive instance eqStyleRule :: Eq StyleRule

putStyleEff :: CSSStyleSheet -> StyleRule -> Effect Unit
putStyleEff st (StyleRule cl tx) = pure $ putStyle st cl tx

createStyleTagEff :: StyleSheetId -> Effect CSSStyleSheet
createStyleTagEff str = pure $ createStyleTag str

main :: Effect Unit
main = do
  styles <- createStyleTagEff "poo"
  putStyleEff styles $ StyleRule "flop" "color: red;"
  pure unit
