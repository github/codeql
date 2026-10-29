function f() {
  var href = window.location.href; // $ Source
  window.location = href.substring(href.indexOf('?')+1); // $ Alert
}
