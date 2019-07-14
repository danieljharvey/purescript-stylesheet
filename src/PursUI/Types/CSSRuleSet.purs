module PursUI.Types.CSSRuleSet where

import Prelude (class Monoid, class Semigroup, map, pure, show, ($), (<<<), (<>))
import PursUI.Types.Primitives

-- | CSSRuleSet is what we build up for a type
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


--- sample

type Props
  = { size :: Int
    , opened :: Boolean
    }

testProps :: Props
testProps
  = { size: 10
    , opened: true
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
