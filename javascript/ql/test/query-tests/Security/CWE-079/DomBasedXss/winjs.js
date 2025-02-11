function test(elt) {
  var tainted = document.location.search.substring(1);
  WinJS.Utilities.setInnerHTMLUnsafe(elt, tainted); // $ TODO-SPURIOUS: Alert
  WinJS.Utilities.setOuterHTMLUnsafe(elt, tainted); // $ TODO-SPURIOUS: Alert
}
