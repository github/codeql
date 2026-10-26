var base64 = require('base-64');

function roundtrip(data) {
  var encoded = base64.encode(data);
  return base64.decode(encoded);
}
