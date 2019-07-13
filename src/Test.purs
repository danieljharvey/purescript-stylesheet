module Testing where

import Prelude (Unit, bind, discard, pure, unit, (>=>), (>>>))
import Data.Maybe (Maybe(..))
import Data.Traversable (traverse_)
import Effect (Effect)
import Effect.Console as Console
import PursUI

import Global.Unsafe (unsafeStringify)

main :: Effect Unit
main = do
  stylesheet <- createStyleTag (StyleSheetId "test")
  _ <- insertRuleIntoStyleSheet stylesheet 
          (InsertRule (CSSSelector ".flop")
                      (CSSText "{ background: green; }")
          )
  _ <- insertRule stylesheet "@media only screen and (max-width: 800px) { .other { color: red; } }"
  ruleList <- getStyleSheetRuleList stylesheet
  rules <- getFilteredRuleList ruleList
  traverse_ (_.item >>> getMediaRuleMediaText >=> Console.logShow) rules.mediaRules
  traverse_ (_.item >>> getMediaRuleRuleList) rules.mediaRules
  what <- findRuleBySelector ruleList (CSSSelector ".flop")
  Console.log (unsafeStringify what)
  insertRuleIntoStyleSheet stylesheet 
    (InsertRule (CSSSelector ".flop")
                (CSSText "tba")
    )
  findMedia <- findMediaQueryByQuery ruleList
                  (MediaQueryText "only screen and (max-width: 800px)")
  case findMedia of
       Just query -> deleteRule stylesheet query.id
       _ -> pure unit
  Console.log (unsafeStringify findMedia)
  pure unit 
