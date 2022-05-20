function test() {
  var src = document.location.search;
  // OK: Closure does not expand external entities
  goog.dom.xml.loadXml(src);
}
