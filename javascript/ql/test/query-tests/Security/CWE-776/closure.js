function test() {
  var src = document.location.search;
  // NOT OK: Closure expands internal entities by default
  goog.dom.xml.loadXml(src);
}
