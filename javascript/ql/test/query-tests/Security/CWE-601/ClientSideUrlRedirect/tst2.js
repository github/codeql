function f() {
  var href = window.location.href;
  // NOT OK
  window.location = href.substring(href.indexOf('?')+1);
}
