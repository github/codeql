function h() {
  var href = window.location.href;

  window.location = "https://github.com?" + href.substring(href.indexOf('?')+1);
}
