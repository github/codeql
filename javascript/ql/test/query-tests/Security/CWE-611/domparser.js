function test() {
  var src = document.location.search; // $ Source=search

  if (window.DOMParser) {
    // OK: DOMParser only expands internal general entities
    new DOMParser().parseFromString(src, 'text/xml');
  } else {
    var parser;
    try {
      // NOT OK: XMLDOM expands external entities by default
      (new ActiveXObject("Microsoft.XMLDOM")).loadXML(src); // $ Alert=search
    } catch (e) {
      // NOT OK: MSXML expands external entities by default
      (new ActiveXObject("Msxml2.DOMDocument")).loadXML(src); // $ Alert=search
    }
  }
}
