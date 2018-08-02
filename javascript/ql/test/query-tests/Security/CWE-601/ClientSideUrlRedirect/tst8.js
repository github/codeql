function k() {
  var search = window.location.search.substr(1);
  // OK
  window.location = "https://lgtm.com" + questionMark() + search;
}

function questionMark() {
  return "?";
}
