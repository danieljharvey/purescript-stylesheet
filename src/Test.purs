module Testing where

import Prelude (Unit, bind, discard, pure, unit, (>=>), (>>>))
import Data.Maybe (Maybe(..))
import Data.Traversable (traverse_)
import Effect (Effect)
import Effect.Console as Console
import PursUI
import CSSOM.Main
import Global.Unsafe (unsafeStringify)

main :: Effect Unit
main = do
  stylesheet <- createStyleTag (StyleSheetId "test")
  _ <- insertRule stylesheet 
          (InsertRule (CSSSelector ".flop")
                      (CSSText "background-color: green;")
          )
  ruleList <- getRuleList' stylesheet
  rules <- getFilteredRuleList ruleList
  traverse_ (_.item >>> getMediaRuleMediaText >=> Console.logShow) rules.mediaRules
  traverse_ (_.item >>> getRuleList') rules.mediaRules
  what <- findRuleBySelector ruleList (CSSSelector ".flop")
  Console.log (unsafeStringify what)
  insertRule stylesheet 
    (InsertRule (CSSSelector ".flop")
                (CSSText "background-color: red")
    )
  findMedia <- findMediaQueryByQuery ruleList
                  (MediaQueryText "only screen and (max-width: 800px)")
  case findMedia of
       Just query -> deleteRule' stylesheet query.id
       _ -> pure unit
  Console.log (unsafeStringify findMedia)
  made <- createAndReturnCSSMediaRule stylesheet 
            (MediaQueryText "only screen and (max-width: 400px)")
  Console.log (unsafeStringify made)
  insertRecursive stylesheet testItem

testItem :: InsertMediaRule
testItem = InsertMediaQuery
              (MediaQueryText "only screen and (max-width: 400px)")
              [ InsertMediaQuery 
                  (MediaQueryText "only screen and (max-height: 400px)")
                  [ InsertStyleRule (InsertRule (CSSSelector ".flop")
                                                (CSSText "font-size: 200px")
                                    )
                  ]
              ]


