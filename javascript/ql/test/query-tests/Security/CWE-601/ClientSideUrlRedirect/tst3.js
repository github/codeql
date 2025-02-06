function g() {
  var href = window.location.href;

  window.location = href.substring(0, href.lastIndexOf('/'));
}
