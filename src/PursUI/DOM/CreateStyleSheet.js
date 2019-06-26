'use strict'

exports.createStyleTagJS = function(id) {
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