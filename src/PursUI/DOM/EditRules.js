"use strict";

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

exports.getStylesheetRulesJS = function(stylesheet) {
  if (!stylesheet) {
    return [];
  }
  const rules = stylesheet.rules || stylesheet.cssRules || {};
  return getFilteredRuleSet(rules)
};

exports.getStyleRuleSelectorText = function(styleRule) {
  return styleRule.selectorText;
}

exports.getStyleRuleDeclarationText = function(styleRule) {
  return styleRule.style.cssText;
}

exports.getMediaRuleStyleRules = function(mediaRule) {
  return getFilteredRuleSet(mediaRule.cssRules) 
}

exports.getMediaRuleMediaText = function(mediaRule) {
  return mediaRule.media.mediaText;
}

// helpers
const getFilteredRuleSet = function(rules) {
  const allStyles = Object.keys(rules).map(function(j) {
    return rules[j];
  });

  return {
    styleRules: allStyles.filter(isStyleRule),
    mediaRules: allStyles.filter(isMediaRule)
  }
}

const isStyleRule = function(a) {
  return a.type === 1
}

const isMediaRule = function(a) {
  return a.type === 4
}
