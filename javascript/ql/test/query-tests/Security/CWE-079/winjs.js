function test(elt) {
  var tainted = document.location.search.substring(1);
  WinJS.Utilities.setInnerHTMLUnsafe(elt, tainted);
  WinJS.Utilities.setOuterHTMLUnsafe(elt, tainted);
}
