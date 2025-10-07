function test() {
  var src = document.location.search; // $ Source=search

  if (window.DOMParser) {
    // OK - DOMParser only expands internal general entities
    new DOMParser().parseFromString(src, 'text/xml');
  } else {
    var parser;
    try {
      (new ActiveXObject("Microsoft.XMLDOM")).loadXML(src); // $ Alert=search // $ Alert - XMLDOM expands external entities by default
    } catch (e) {
      (new ActiveXObject("Msxml2.DOMDocument")).loadXML(src); // $ Alert=search // $ Alert - MSXML expands external entities by default
    }
  }
}
