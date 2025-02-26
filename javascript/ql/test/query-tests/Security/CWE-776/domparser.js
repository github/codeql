function test() {
  var src = document.location.search; // $ Source

  if (window.DOMParser) {
    new DOMParser().parseFromString(src, 'text/xml'); // $ Alert - DOMParser expands internal entities by default
  } else {
    var parser;
    try {
      (new ActiveXObject("Microsoft.XMLDOM")).loadXML(src); // $ Alert - XMLDOM expands internal entities by default
    } catch (e) {
      (new ActiveXObject("Msxml2.DOMDocument")).loadXML(src); // $ Alert - MSXML expands internal entities by default
    }
  }
}
