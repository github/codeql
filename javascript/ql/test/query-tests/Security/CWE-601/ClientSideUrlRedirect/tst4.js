function h() {
  var href = window.location.href;
  // OK
  window.location = "https://lgtm.com?" + href.substring(href.indexOf('?')+1);
}
