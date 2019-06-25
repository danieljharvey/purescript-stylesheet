module StyleLens where

import Prelude (class Monoid, class Semigroup, flap, map, mempty, pure, show, ($), (<<<), (<>))
import Data.Foldable (foldr)
import PursUI.Internal.Types

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

data StyleRule
  = ClassRule CSSText
  | MediaRule MediaQueryText StyleRuleSet

newtype StyleRuleSet
  = StyleRuleSet (Array StyleRule)

classRule :: CSSText -> StyleRuleSet
classRule = StyleRuleSet <<< pure <<< ClassRule

mediaRule :: MediaQueryText -> StyleRuleSet -> StyleRuleSet
mediaRule queryStr subStyle
  = StyleRuleSet <<< pure $ MediaRule queryStr subStyle

derive newtype instance semigroupStyleRuleSet :: Semigroup StyleRuleSet
derive newtype instance monoidStyleRuleSet    :: Monoid StyleRuleSet

processStyle
  :: forall props
   . CSSRuleSet props
  -> props
  -> StyleRuleSet
processStyle (CSSRuleSet styles) props
  = foldr (<>) mempty $ flap (map renderer styles) props
  where
    renderer style props'
      = case style of
          Const string    -> classRule string
          Lens f          -> classRule (f props')
          MediaQuery s as -> mediaRule s (processStyle as props')

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
renderStyle 
  :: forall props
   . props
  -> StyleMaker props 
  -> StyleRuleMaker
renderStyle props (StyleMaker styles)
  = foldr (<>) mempty $ flap (map everythingRenderer styles) props

makeRenderer 
  :: forall props
   . CSSRule props 
  -> props 
  -> StyleRuleMaker
makeRenderer rule p 
  = case rule of
      Const s -> s
      Lens a  -> a p


b :: CSSText
b = renderStyle { size: 10, opened: false } makeStyle

c :: CSSText
c = renderStyle { size: 200, opened: true } makeStyle

-}
