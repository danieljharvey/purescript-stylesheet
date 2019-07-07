module Testing where

import Prelude (Unit, bind, discard, pure, unit, (>=>))
import Data.Traversable (traverse_)
import Effect (Effect)
import Effect.Console as Console
import Effect.Uncurried (runEffectFn1, runEffectFn2)
import PursUI

main :: Effect Unit
main = do
  stylesheet <- runEffectFn1 createStyleTagJS "test"
  _ <- runEffectFn2 insertRuleJS stylesheet ".flop { background: green; }"
  _ <- runEffectFn2 insertRuleJS stylesheet "@media only screen and (max-width: 800px) { .other { color: red; } }"
  rules <- runEffectFn1 getStylesheetRulesJS stylesheet
  traverse_ (runEffectFn1 getStyleRuleDeclarationText >=> Console.log) rules.styleRules
  traverse_ (runEffectFn1 getMediaRuleMediaText >=> Console.log) rules.mediaRules
  pure unit 
