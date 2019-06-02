"use strict";

exports.putStyle = function(stylesheet) {
  return function(className_) {
    return function(text) {
      var newIndex = findStyle(stylesheet, className_);
      if (newIndex > -1) {
        deleteRule(stylesheet, newIndex);
      }
      insertRule(stylesheet, className_, text);
    }
  }
}

exports.createStyleTag = function(id) {
  var css = "";
  var head = document.head || document.getElementsByTagName("head")[0];
  var style = document.createElement("style");

  style.type = "text/css";
  style.id = id;
  if (style.styleSheet) {
    // This is required for IE8 and below.
    style.styleSheet.cssText = css;
  } else {
    style.appendChild(document.createTextNode(css));
  }

  head.appendChild(style);
  return findStylesheetById(document, id);
};

function addSelectorText(selectorText, cssText) {
  return "." + selectorText + " { " + cssText + " }";
};

function findStylesheetById(_document, id) {
  var foundId = Object.keys(_document.styleSheets).find(function(i) {
    var sheet = _document.styleSheets[i];
    return sheet && sheet.ownerNode && sheet.ownerNode.id === id;
  });
  if (foundId) {
    return _document.styleSheets[foundId];
  } else {
    throw Error("oh no, could not find")
  }
};

function getStylesheetRules(stylesheet) {
  if (!stylesheet) {
    return [];
  }
  var rules = stylesheet.rules || stylesheet.cssRules || {};

  return Object.keys(rules).map(function(j) {
    return rules[j];
  });
};


function deleteRule(stylesheet, newIndex) {
  if (stylesheet) {
    stylesheet.deleteRule(newIndex);
  }
};

function insertRule(stylesheet, className_, text) {
  if (stylesheet) {
    stylesheet.insertRule(addSelectorText(className_, text));
  }
};

function findStyle(stylesheet, className_) {
  return getStylesheetRules(stylesheet).reduce(function(all, item, index) {
    if (item.selectorText === "." + className_) {
      return index;
    }
    return all;
  }, -1);
}
