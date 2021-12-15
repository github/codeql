function roundtrip(data) {
  var encoded = Buffer.from(data, 'base64');
  return encoded.toString('base64');
}

function roundtrip2(data) {
  var encoded = Buffer.from(data, 'hex');
  return encoded.toString('hex');
}
