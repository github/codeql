var http = require("http"),
  url = require("url"),
  fs = require("fs");

var server = http.createServer(function(req, res) {
  let s = url.parse(req.url, true).query.s;
  let n = parseInt(s);

  Buffer.from(s); // OK
  Buffer.from(n); // OK
  Buffer.from(x, n); // OK
  Buffer.from(x, y, s); // NOT OK
  Buffer.from(x, y, n); // NOT OK
  Buffer.from(x, y, n); // NOT OK
  Buffer.alloc(n); // NOT OK
  Buffer.allocUnsafe(n); // NOT OK
  Buffer.allocUnsafeSlow(n); // NOT OK

  new Buffer(n); // NOT OK
  new Buffer(x, n); // OK
  new Buffer(x, y, n); // NOT OK

  new SlowBuffer(n); // NOT OK

  Array(n); // OK
  new Array(n); // OK

  Array(n).map(); // NOT OK
  new Array(n).map(); // NOT OK
  Array(n).fill(); // NOT OK
  Array(n).join(); // NOT OK
  Array(n).toString(); // NOT OK
  Array(n) + x; // NOT OK

  x.repeat(n); // NOT OK
  x.repeat(s); // NOT OK

  new Buffer(n * x); // NOT OK
  new Buffer(n + n); // NOT OK
  new Buffer(n + x); // NOT OK (maybe)
  new Buffer(n + s); // OK [INCONSISTENCY]: this is  a string if `s` is a string
  new Buffer(s + 2); // OK [INCONSISTENCY]: this is  a string if `s` is a string
  new Buffer(s + s); // OK
  new Buffer(n + "X"); // OK

  new Buffer(Math.ceil(s)); // NOT OK
  new Buffer(Number(s)); // NOT OK
  new Buffer(new Number(s)); // OK

  new Buffer(s + x.length); // OK [INCONSISTENCY]: this is a string if `s` is a string
  new Buffer(s.length); // NOT OK

  if (n < 100) {
    new Buffer(n); // OK
  } else {
    new Buffer(n); // NOT OK
  }

  let ns = x ? n : s;
  new Buffer(ns); // NOT OK

  new Buffer(n.toString()); // OK

  if (typeof n === "string") {
    new Buffer(n); // OK
  } else {
    new Buffer(n); // NOT OK
  }

  if (typeof n === "number") {
    new Buffer(n); // NOT OK
  } else {
    new Buffer(n); // OK
  }

  if (typeof s === "number") {
    new Buffer(s); // NOT OK [INCONSISTENCY]
  } else {
    new Buffer(s); // OK
  }

});
