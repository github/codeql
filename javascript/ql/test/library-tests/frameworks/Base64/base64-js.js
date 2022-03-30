var base64 = require('base64-js');

function roundtrip(data) {
  var encoded = base64.toByteArray(data);
  return base64.fromByteArray(encoded);
}
