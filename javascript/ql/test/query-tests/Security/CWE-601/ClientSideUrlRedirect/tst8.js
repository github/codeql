function k() {
  var search = window.location.search.substr(1);
  // OK
  window.location = "https://github.com" + questionMark() + search;
}

function questionMark() {
  return "?";
}
