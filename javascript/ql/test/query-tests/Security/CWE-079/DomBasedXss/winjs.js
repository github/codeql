function test(elt) {
  var tainted = document.location.search.substring(1); // $ Source
  WinJS.Utilities.setInnerHTMLUnsafe(elt, tainted); // $ Alert
  WinJS.Utilities.setOuterHTMLUnsafe(elt, tainted); // $ Alert
}
