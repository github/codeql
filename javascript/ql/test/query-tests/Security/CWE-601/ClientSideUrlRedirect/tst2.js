function f() {
  var href = window.location.href;
  window.location = href.substring(href.indexOf('?')+1); // $ Alert
}
