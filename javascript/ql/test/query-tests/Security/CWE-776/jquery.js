function test() {
  var src = document.location.search;

  // NOT OK: jQuery expands internal entities by default
  $.parseXML(src);
}
