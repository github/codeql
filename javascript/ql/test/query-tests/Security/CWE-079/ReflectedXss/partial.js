let express = require('express');
let underscore = require('underscore');
let lodash = require('lodash');
let R = require('ramda');

let app = express();

app.get("/some/path", (req, res) => {
  function sendResponse(x, y) {
    res.send(x + y); // NOT OK
  }
  
  let callback = sendResponse.bind(null, req.url);
  [1, 2, 3].forEach(callback);
});

app.get("/underscore", (req, res) => {
  function sendResponse(x, y) {
    res.send(x + y); // NOT OK
  }
  
  let callback = underscore.partial(sendResponse, req.url);
  [1, 2, 3].forEach(callback);
});

app.get("/lodash", (req, res) => {
  function sendResponse(x, y) {
    res.send(x + y); // NOT OK
  }
  
  let callback = lodash.partial(sendResponse, req.url);
  [1, 2, 3].forEach(callback);
});

app.get("/ramda", (req, res) => {
  function sendResponse(x, y) {
    res.send(x + y); // NOT OK
  }
  
  let callback = R.partial(sendResponse, [req.url]);
  [1, 2, 3].forEach(callback);
});

app.get("/return", (req, res) => {
  function getFirst(x, y) {
    return x;
  }

  let callback = getFirst.bind(null, req.url);

  res.send(callback);   // OK - the callback itself is not tainted
  res.send(callback()); // NOT OK - but not currently detected [INCONSISTENCY]

  res.send(getFirst("Hello")); // OK - argument is not tainted from this call site
});
