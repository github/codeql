function test() {
  var src = document.location.search;

  $.parseXML(src); // $ Alert - jQuery expands internal entities by default
}
