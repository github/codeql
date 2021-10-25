function roundtrip(data) {
  var encoded = btoa(data);
  return atob(encoded);
}
