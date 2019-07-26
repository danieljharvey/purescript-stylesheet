module Stylesheet.Internal.AddStyle where

import Prelude (discard, pure)
import Effect (Effect)
import Data.Foldable (foldMap)

import Stylesheet.Types.Stylesheet (Stylesheet(..), addVirtualStylesheet)
import Stylesheet.Types.CSSRuleSet (CSSRuleSet)
import Stylesheet.Types.Primitives (CSSSelector)
import Stylesheet.Types.VirtualStylesheet

import Stylesheet.Internal.ProcessStyles (getClasses, keep, processStyle) 

-- | This is the top level big dog of a function, as such
-- | We provide the big Stylesheet doing-things-lump
-- | a function from props -> Styles
-- | some props
-- | and we get back a bunch of CSSSelectors (classes)
addStyle 
  :: forall p props
   . Stylesheet p
  -> CSSRuleSet props
  -> props
  -> Effect (Array CSSSelector)
addStyle stylesheet styleRule props = do
  let rules = keep (processStyle styleRule props)
      virtualStylesheet = foldMap (fromItem) rules
      classes = foldMap (getClasses) rules 
  addVirtualStylesheet stylesheet virtualStylesheet 
  pure classes 
