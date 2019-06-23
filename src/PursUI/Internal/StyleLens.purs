module StyleLens where

import Prelude (class Semigroup, const, flap, identity, map, mempty, pure, show, ($), (<<<), (<>))
import Data.Foldable (foldr)
import PursUI.Internal.Types

newtype StyleMaker p
  = StyleMaker (Array (CSSRule p))

instance styleMakerSemigroup :: Semigroup (StyleMaker a) where
  append (StyleMaker as) (StyleMaker bs) = StyleMaker (as <> bs)

data CSSRule p
  = Const CSSText
  | Lens (p -> CSSText)

type Props
  = { size :: Int
    , opened :: Boolean
    }

str :: forall props. String -> StyleMaker props
str = StyleMaker <<< pure <<< Const <<< CSSText

fun :: forall props. (props -> String) -> StyleMaker props
fun = StyleMaker <<< pure <<< Lens <<< (map CSSText)

makeStyle :: StyleMaker Props
makeStyle
  =  str """
         background-color: black;
         height: 100px;
         """
  <> fun (\p -> "width: " <> (show p.size) <> "px;")
  <> fun (\p -> if p.opened 
                 then "border: 1px black solid;" 
                 else "border: none;")

renderStyle 
  :: forall props
   . props
  -> StyleMaker props 
  -> CSSText
renderStyle props (StyleMaker styles)
  = foldr (<>) mempty $ flap (map everythingRenderer styles) props

makeRenderer 
  :: forall props
   . (CSSText -> CSSText)
  -> (CSSText -> CSSText)
  -> CSSRule props 
  -> props 
  -> CSSText
makeRenderer constF lensF f p 
  = case f of
      Const s -> (constF s)
      Lens a  -> lensF (a p)

dynamicRenderer :: forall p. CSSRule p -> p -> CSSText
dynamicRenderer = makeRenderer (const mempty) identity

staticRenderer :: forall p. CSSRule p -> p -> CSSText
staticRenderer = makeRenderer identity (const mempty)

everythingRenderer :: forall p. CSSRule p -> p -> CSSText
everythingRenderer = makeRenderer identity identity 

b :: CSSText
b = renderStyle { size: 10, opened: false } makeStyle

c :: CSSText
c = renderStyle { size: 200, opened: true } makeStyle


