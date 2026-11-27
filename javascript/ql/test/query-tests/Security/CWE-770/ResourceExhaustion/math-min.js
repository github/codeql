const http = require("http");
const url = require("url");
const MAX = 1024;
const FRACTIONAL_MAX = 10.5;

http.createServer((req, res) => {
  const query = url.parse(req.url, true).query; // $ Source
  const n = parseInt(query.n);
  const other = parseInt(query.other);

  Buffer.alloc(Math.min(n, 1024));
  Buffer.alloc(Math.min(MAX, n));
  Buffer.alloc(Math.min(n, other, MAX));
  Buffer.alloc(Math.min(n, FRACTIONAL_MAX));
  Buffer.alloc(Math.min(n, 0x400));
  Buffer.alloc(Math.min(n, -1));
  Buffer.alloc(Math.min(n, +1.5));
  let localMax = 2048;
  localMax = 1024;
  Buffer.alloc(Math.min(n, localMax));
  new Array(Math.min(n, MAX)).fill(0);
  "-".repeat(Math.min(n, MAX));
  setTimeout(() => {}, Math.min(n, MAX));
  setInterval(() => {}, Math.min(n, MAX));
  const size = Math.max(0, Math.min(n, MAX));
  Buffer.alloc(size);

  Buffer.alloc(Math.min(n)); // $ Alert
  Buffer.alloc(Math.min(n, other)); // $ Alert
  Buffer.alloc(Math.max(n, MAX)); // $ Alert
  Buffer.alloc(Math.ceil(n)); // $ Alert
  Buffer.alloc(Math.min(n, Infinity)); // $ Alert
  Buffer.alloc(Math.min(n, 1e999)); // $ Alert

  let bound = 1024;
  bound = other;
  Buffer.alloc(Math.min(n, bound)); // $ Alert
  let updated = 1024;
  updated *= other;
  Buffer.alloc(Math.min(n, updated)); // $ Alert
  let incremented = 1024;
  incremented++;
  Buffer.alloc(Math.min(n, incremented)); // $ Alert
  let destructured = 1024;
  [destructured] = [other];
  Buffer.alloc(Math.min(n, destructured)); // $ Alert
  for (let iteration of [other]) {
    Buffer.alloc(Math.min(n, iteration)); // $ Alert
    iteration = 1024;
  }
  let loopBound = 1024;
  for ((loopBound) of [other]) {
    Buffer.alloc(Math.min(n, loopBound)); // $ Alert
  }
  let parenthesizedBound = 1024;
  (parenthesizedBound) = other;
  Buffer.alloc(Math.min(n, parenthesizedBound)); // $ Alert
  var redeclared = 1024;
  var { redeclared } = { redeclared: other };
  Buffer.alloc(Math.min(n, redeclared)); // $ Alert

  function useParameter(limit = 1024) {
    Buffer.alloc(Math.min(n, limit)); // $ Alert
  }
  useParameter(other);
});
