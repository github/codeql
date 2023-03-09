function h() {
  var href = window.location.href;
  // OK
  window.location = "https://github.com?" + href.substring(href.indexOf('?')+1);
}
