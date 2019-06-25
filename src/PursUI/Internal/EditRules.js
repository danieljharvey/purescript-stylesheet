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
  var rules = stylesheet.rules || stylesheet.cssRules || {};

  return Object.keys(rules).map(function(j) {
    return rules[j];
  });
};
