var Base64 = require("Base64");

function roundtrip(data) {
  var encoded = Base64.btoa(data);
  return Base64.atob(encoded);
}
