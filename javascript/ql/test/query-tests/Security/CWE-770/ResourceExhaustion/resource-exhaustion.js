var http = require("http"),
    url = require("url");

var server = http.createServer(function(req, res) {
  let s = url.parse(req.url, true).query.s; // $ Source
  let n = parseInt(s);

  Buffer.from(s);
  Buffer.from(n);
  Buffer.from(x, n);
  Buffer.from(x, y, s); // OK - does not allocate memory
  Buffer.from(x, y, n); // OK - does not allocate memory
  Buffer.from(x, y, n); // OK - does not allocate memory
  Buffer.alloc(n); // $ Alert
  Buffer.allocUnsafe(n); // $ Alert
  Buffer.allocUnsafeSlow(n); // $ Alert

  new Buffer(n); // $ MISSING: Alert
  new Buffer(x, n);
  new Buffer(x, y, n); // $ Alert

  new SlowBuffer(n); // $ Alert

  Array(n);
  new Array(n);

  Array(n).map(); // $ Alert
  new Array(n).map(); // $ Alert
  Array(n).fill(); // $ Alert
  Array(n).join(); // $ Alert
  Array(n).toString(); // $ Alert
  Array(n) + x; // $ Alert

  x.repeat(n); // $ Alert
  x.repeat(s); // $ Alert

  new Buffer(n * x); // $ MISSING: Alert
  new Buffer(n + n); // $ MISSING: Alert
  new Buffer(n + x); // OK - maybe
  new Buffer(n + s); // OK - this is  a string if `s` is a string
  new Buffer(s + 2); // OK - this is  a string if `s` is a string
  new Buffer(s + s);
  new Buffer(n + "X");

  new Buffer(Math.ceil(s)); // $ MISSING: Alert
  new Buffer(Number(s)); // $ MISSING: Alert
  new Buffer(new Number(s));

  new Buffer(s + x.length); // OK - this is a string if `s` is a string
  new Buffer(s.length); // $ MISSING: Alert

  if (n < 100) {
    new Buffer(n);
  } else {
    new Buffer(n); // $ MISSING: Alert
  }

  let ns = x ? n : s;
  new Buffer(ns); // $ MISSING: Alert

  new Buffer(n.toString());

  if (typeof n === "string") {
    new Buffer(n);
  } else {
    new Buffer(n); // $ MISSING: Alert
  }

  if (typeof n === "number") {
    new Buffer(n); // $ MISSING: Alert
  } else {
    new Buffer(n);
  }

  if (typeof s === "number") {
    new Buffer(s); // $ MISSING: Alert
  } else {
    new Buffer(s);
  }

  setTimeout(f, n); // $ Alert
  setTimeout(f, s); // $ Alert
  setInterval(f, n); // $ Alert
  setInterval(f, s); // $ Alert

  Buffer.alloc(n.length); // OK - only allocing as much as the length of the input.

  Buffer.alloc(n); // $ Alert
  if (n < 1000) {
    Buffer.alloc(n); // OK - length check
  } else {
    Buffer.alloc(n); // $ Alert - NO length check
  }
});

function browser() {
    const delay = parseInt(window.location.search.replace('?', '')) || 5000;
    setTimeout(() => {
        console.log("f00");
    }, delay); // OK - source is client side

    window.onmessage = (e) => {
        setTimeout(() => {}, e.data); // OK - source is client side
    }
}