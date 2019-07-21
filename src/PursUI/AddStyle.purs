module PursUI.AddStyle where

import Prelude (discard, pure)
import Effect (Effect)
import Data.Foldable (foldMap)

import PursUI.Types.PursUI (PursUI, addVirtualStyleSheet)
import PursUI.Types.CSSRuleSet (CSSRuleSet)
import PursUI.Types.Primitives (CSSSelector)
import PursUI.Types.VirtualStyleSheet

import PursUI.StyleLens (getClasses, keep, processStyle) 

-- | This is the top level big dog of a function, as such
-- | We provide the big PursUI doing-things-lump
-- | a function from props -> Styles
-- | some props
-- | and we get back a bunch of CSSSelectors (classes)
addStyle 
  :: forall p props
   . PursUI p
  -> CSSRuleSet props
  -> props
  -> Effect (Array CSSSelector)
addStyle pursUI styleRule props = do
  let rules = keep (processStyle styleRule props)
      virtualStyleSheet = foldMap (fromItem) rules
      classes = foldMap (getClasses) rules 
  addVirtualStyleSheet pursUI virtualStyleSheet 
  pure classes 
