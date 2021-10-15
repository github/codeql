var express = require('express');
var app = express();

var actions = new Map();
actions.put("play", function (data) {
  // ...
});
actions.put("pause", function(data) {
  // ...
});

app.get('/perform/:action/:payload', function(req, res) {
  if (actions.has(req.params.action)) {
    let action = actions.get(req.params.action);
    res.end(action(req.params.payload));
  } else {
    res.end("Unsupported action.");
  }
});
