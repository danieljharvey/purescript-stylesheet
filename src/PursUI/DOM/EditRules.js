"use strict";

exports.getStyleSheetRuleListJS = function(stylesheet) {
  console.log('stylesheetcssrules', stylesheet.cssRules)
  return stylesheet.cssRules;
}

exports.insertRuleJS = function(stylesheet, text) {
  if (stylesheet) {
    stylesheet.insertRule(text);
  }
}

exports.deleteRuleJS = function(stylesheet, index) {
  if (stylesheet) {
    stylesheet.deleteRule(index)
  }
}

exports.getStyleRuleSelectorTextJS = function(styleRule) {
  return styleRule.selectorText;
}

exports.getStyleRuleDeclarationTextJS = function(styleRule) {
  return styleRule.style.cssText;
}

exports.insertMediaRuleRuleJS = function(mediaRule, text) {
  mediaRule.insertRule(text, 0);
}

exports.getMediaRuleRuleListJS = function(mediaRule) {
  return mediaRule.cssRules;
}

exports.getMediaRuleMediaTextJS = function(mediaRule) {
  return mediaRule.media.mediaText;
}

exports.getFilteredRuleListJS = function(rules) {
  const allStyles = Object.keys(rules).map(function(j) {
    return { id: j
           , item: rules[j]
           }
  });

  return {
    styleRules: allStyles.filter(isStyleRule),
    mediaRules: allStyles.filter(isMediaRule)
  }
}

// helpers
//
const isStyleRule = function(a) {
  return a.item.type === 1
}

const isMediaRule = function(a) {
  return a.item.type === 4
}
