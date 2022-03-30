function g() {
  var href = window.location.href;
  // OK
  window.location = href.substring(0, href.lastIndexOf('/'));
}
