let express = require('express');
let underscore = require('underscore');
let lodash = require('lodash');
let R = require('ramda');

let app = express();

app.get("/some/path", (req, res) => {
  function sendResponse(x, y) {
    res.send(x + y); // $ Alert
  }
  
  let callback = sendResponse.bind(null, req.url); // $ Source
  [1, 2, 3].forEach(callback);
});

app.get("/underscore", (req, res) => {
  function sendResponse(x, y) {
    res.send(x + y); // $ Alert
  }
  
  let callback = underscore.partial(sendResponse, req.url); // $ Source
  [1, 2, 3].forEach(callback);
});

app.get("/lodash", (req, res) => {
  function sendResponse(x, y) {
    res.send(x + y); // $ Alert
  }
  
  let callback = lodash.partial(sendResponse, req.url); // $ Source
  [1, 2, 3].forEach(callback);
});

app.get("/ramda", (req, res) => {
  function sendResponse(x, y) {
    res.send(x + y); // $ Alert
  }
  
  let callback = R.partial(sendResponse, [req.url]); // $ Source
  [1, 2, 3].forEach(callback);
});

app.get("/return", (req, res) => {
  function getFirst(x, y) {
    return x;
  }

  let callback = getFirst.bind(null, req.url);

  res.send(callback);   // OK - the callback itself is not tainted
  res.send(callback()); // $ MISSING: Alert - not currently detected

  res.send(getFirst("Hello")); // OK - argument is not tainted from this call site
});
