module Testing where

import Prelude
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
          (InsertRule (CSSClassSelector "flop")
                      (CSSText "background-color: green;")
          )
  ruleList <- getRuleList' stylesheet
  rules <- getFilteredRuleList ruleList
  traverse_ (_.item >>> getMediaRuleMediaText >=> Console.logShow) rules.mediaRules
  traverse_ (_.item >>> getRuleList') rules.mediaRules
  what <- findRuleBySelector ruleList (CSSClassSelector "flop")
  Console.log (unsafeStringify what)
  insertRule stylesheet 
    (InsertRule (CSSClassSelector "flop")
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
  traverse_ (insertRecursive stylesheet) testItem2
  traverse_ (Console.log <<< unsafeStringify <<< getClasses) testItem2
  traverse_ (insertRecursive stylesheet) testItem3
  traverse_ (Console.log <<< unsafeStringify <<< getClasses) testItem3


testItem2 :: Array InsertMediaRule
testItem2 = keep (processStyle makeTestStyle testProps)

testItem3 :: Array InsertMediaRule
testItem3 = keep (processStyle makeTestStyle testProps2)

--- sample

type Props
  = { size :: Int
    , opened :: Boolean
    }

testProps :: Props
testProps
  = { size: 300
    , opened: true
    }

testProps2 :: Props
testProps2
  = { size: 10
    , opened: false
    }

makeTestStyle :: CSSRuleSet Props
makeTestStyle
  =  str """
         background-color: black;
         height: 100px;
         """
  <> fun (\p -> "width: " <> (show p.size) <> "px;")
  <> fun (\p -> if p.opened 
                 then "border: 1px black solid;" 
                 else "border: none;")
  <> media "max-width: 800px"
      (str "color: red;")

testItem :: InsertMediaRule
testItem = InsertMediaQuery
              (MediaQueryText "only screen and (max-width: 400px)")
              [ InsertMediaQuery 
                  (MediaQueryText "only screen and (max-height: 400px)")
                  [ InsertStyleRule (InsertRule (CSSClassSelector "flop")
                                                (CSSText "font-size: 200px")
                                    )
                  ]
              ]


