function test() {
  var src = document.location.search;

  if (window.DOMParser) {
    // NOT OK: DOMParser expands internal entities by default
    new DOMParser().parseFromString(src, 'text/xml');
  } else {
    var parser;
    try {
       // NOT OK: XMLDOM expands internal entities by default
      (new ActiveXObject("Microsoft.XMLDOM")).loadXML(src);
    } catch (e) {
      // NOT OK: MSXML expands internal entities by default
      (new ActiveXObject("Msxml2.DOMDocument")).loadXML(src);
    }
  }
}
