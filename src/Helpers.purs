module Helpers where
  
import Prelude
import Data.List as List
import Data.Set as Set
import Data.Foldable (foldr)

setToList :: forall a. Set.Set a -> List.List a
setToList set = foldr (\item total -> List.snoc total item) mempty set