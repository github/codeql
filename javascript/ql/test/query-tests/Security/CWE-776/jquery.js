function test() {
  var src = document.location.search; // $ Source

  $.parseXML(src); // $ Alert - jQuery expands internal entities by default
}
