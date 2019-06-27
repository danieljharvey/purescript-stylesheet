module PursUI.StyleLens where

import Prelude (class Monoid, class Semigroup, class Show, flap, map, pure, show, ($), (<<<), (<>))
import PursUI.Types.Primitives

---

-- input

newtype CSSRuleSet p
  = CSSRuleSet (Array (CSSRule p))

derive newtype instance semigroupCSSRuleSet :: Semigroup (CSSRuleSet p)
derive newtype instance monoidCSSRuleSet    :: Monoid (CSSRuleSet p)

data CSSRule p
  = Const CSSText
  | Lens (p -> CSSText)
  | MediaQuery MediaQueryText (CSSRuleSet p)

str :: forall props. String -> CSSRuleSet props
str = CSSRuleSet <<< pure <<< Const <<< CSSText

fun :: forall props. (props -> String) -> CSSRuleSet props
fun = CSSRuleSet <<< pure <<< Lens <<< (map CSSText)

media :: forall props. String -> CSSRuleSet props -> CSSRuleSet props
media queryStr subStyle
  = CSSRuleSet <<< pure $ MediaQuery (MediaQueryText queryStr) subStyle

---

-- output
-- friendly format for putting into cssom

-- these are split out so when we filter one kind out we can represent the
-- separate ones on the type level
data RuleType
  = ClassType ClassRule
  | MediaType MediaRule

instance showRuleType :: Show RuleType where
  show (ClassType rule) = "ClassType: " <> show rule
  show (MediaType rule) = "MediaType: " <> show rule

newtype ClassRule
  = ClassRule CSSText

derive newtype instance showClassRule :: Show ClassRule

data MediaRule 
  = MediaRule MediaQueryText (Array RuleType)

instance showMediaRule :: Show MediaRule where
  show (MediaRule query rules) 
    = "MediaRule: " <> show query <> ", " <> show rules

newtype StyleRuleSet
  = StyleRuleSet (Array RuleType)

wrapInRuleSet :: Array RuleType -> StyleRuleSet
wrapInRuleSet = StyleRuleSet

classRule :: CSSText -> RuleType
classRule = ClassType <<< ClassRule

mediaRule :: MediaQueryText -> Array RuleType -> RuleType
mediaRule queryStr subStyles
  = MediaType $ MediaRule queryStr subStyles

derive newtype instance showStyleRuleSet      :: Show StyleRuleSet
derive newtype instance semigroupStyleRuleSet :: Semigroup StyleRuleSet
derive newtype instance monoidStyleRuleSet    :: Monoid StyleRuleSet

processStyle
  :: forall props
   . CSSRuleSet props
  -> props
  -> StyleRuleSet
processStyle ruleSet props
  = wrapInRuleSet (process ruleSet)
  where
    process :: CSSRuleSet props -> Array RuleType
    process (CSSRuleSet styles')
     = flap (map renderer styles') props
    
    renderer style props'
      = case style of
          Const string    -> classRule string
          Lens f          -> classRule (f props')
          MediaQuery s as -> mediaRule s (process as)

-- for now we'll discard media query ones
-- and just output the basic bullshit

outputClassRule
  :: ClassRule
  -> String
outputClassRule rule
  = ".blah { " <> show rule <> "}"

{-
outputStyleRuleSet
  :: StyleRuleSet
  -> String
outputStyleRuleSet (StyleRuleSet items)
  = foldr (<>) mempty (map (outputClassRule <<< filterClassRules) items)
  -}


{-

expected:

.hash {
  background-color: black;
  height: 100px;
  width: 100px;
  border: none;
}

@media (max-width: 600px) {
  .hash2 {
    color: red;
  }
}

-}

---

--- sample

type Props
  = { size :: Int
    , opened :: Boolean
    }


makeStyle :: CSSRuleSet Props
makeStyle
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

{-
b :: StyleRuleSet
b = processStyle makeStyle { size: 10, opened: false }

c :: StyleRuleSet
c = processStyle makeStyle { size: 200, opened: true }
  -}
