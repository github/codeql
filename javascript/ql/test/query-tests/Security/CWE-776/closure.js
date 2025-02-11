function test() {
  var src = document.location.search;
  goog.dom.xml.loadXml(src); // $ Alert - Closure expands internal entities by default
}
