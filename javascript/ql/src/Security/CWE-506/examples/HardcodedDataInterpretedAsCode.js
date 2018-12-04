var r = require;

function e(r) {
  return Buffer.from(r, "hex").toString()
}

// BAD: hexadecimal constant decoded and interpreted as import path
var n = r(e("2e2f746573742f64617461"));
