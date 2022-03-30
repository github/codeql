// this file contains many `NOT OK [INCONSISTENCY]` annotations, those
// would be resolved if the query used flow labels to recognice
// numbers flowing to sinks

var http = require("http"),
    url = require("url");

var server = http.createServer(function(req, res) {
  let s = url.parse(req.url, true).query.s;
  let n = parseInt(s);

  Buffer.from(s); // OK
  Buffer.from(n); // OK
  Buffer.from(x, n); // OK
  Buffer.from(x, y, s); // NOT OK
  Buffer.from(x, y, n); // NOT OK [INCONSISTENCY]
  Buffer.from(x, y, n); // NOT OK [INCONSISTENCY]
  Buffer.alloc(n); // NOT OK [INCONSISTENCY]
  Buffer.allocUnsafe(n); // NOT OK [INCONSISTENCY]
  Buffer.allocUnsafeSlow(n); // NOT OK [INCONSISTENCY]

  new Buffer(n); // NOT OK [INCONSISTENCY]
  new Buffer(x, n); // OK
  new Buffer(x, y, n); // NOT OK [INCONSISTENCY]

  new SlowBuffer(n); // NOT OK [INCONSISTENCY]

  Array(n); // OK
  new Array(n); // OK

  Array(n).map(); // NOT OK [INCONSISTENCY]
  new Array(n).map(); // NOT OK [INCONSISTENCY]
  Array(n).fill(); // NOT OK [INCONSISTENCY]
  Array(n).join(); // NOT OK [INCONSISTENCY]
  Array(n).toString(); // NOT OK [INCONSISTENCY]
  Array(n) + x; // NOT OK [INCONSISTENCY]

  x.repeat(n); // NOT OK
  x.repeat(s); // NOT OK

  new Buffer(n * x); // NOT OK [INCONSISTENCY]
  new Buffer(n + n); // NOT OK [INCONSISTENCY]
  new Buffer(n + x); // OK (maybe)
  new Buffer(n + s); // OK (this is  a string if `s` is a string)
  new Buffer(s + 2); // OK (this is  a string if `s` is a string)
  new Buffer(s + s); // OK
  new Buffer(n + "X"); // OK

  new Buffer(Math.ceil(s)); // NOT OK [INCONSISTENCY]
  new Buffer(Number(s)); // NOT OK [INCONSISTENCY]
  new Buffer(new Number(s)); // OK

  new Buffer(s + x.length); // OK (this is a string if `s` is a string)
  new Buffer(s.length); // NOT OK [INCONSISTENCY]

  if (n < 100) {
    new Buffer(n); // OK
  } else {
    new Buffer(n); // NOT OK [INCONSISTENCY]
  }

  let ns = x ? n : s;
  new Buffer(ns); // NOT OK [INCONSISTENCY]

  new Buffer(n.toString()); // OK

  if (typeof n === "string") {
    new Buffer(n); // OK
  } else {
    new Buffer(n); // NOT OK [INCONSISTENCY]
  }

  if (typeof n === "number") {
    new Buffer(n); // NOT OK [INCONSISTENCY]
  } else {
    new Buffer(n); // OK
  }

  if (typeof s === "number") {
    new Buffer(s); // NOT OK [INCONSISTENCY]
  } else {
    new Buffer(s); // OK
  }

  setTimeout(f, n); // NOT OK
  setTimeout(f, s); // NOT OK
  setInterval(f, n); // NOT OK
  setInterval(f, s); // NOT OK
});
