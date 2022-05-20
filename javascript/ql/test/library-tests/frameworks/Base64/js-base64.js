var base64 = require('js-base64').Base64;

function roundtrip1(data) {
  var encoded = base64.encode(data);
  return base64.decode(encoded);
}

function roundtrip2(data) {
  var encoded = base64.encodeURI(data);
  return base64.decode(encoded);
}
