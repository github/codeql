function test() {
  var src = document.location.search; // $ Source
  goog.dom.xml.loadXml(src); // $ Alert - Closure expands internal entities by default
}
