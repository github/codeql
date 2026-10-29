var express = require('express');
var app = express();

var actions = new Map();
actions.set("play", function play(data) {
  // ...
});
actions.set("pause", function pause(data) {
  // ...
});

app.get('/perform/:action/:payload', function(req, res) {
  if (actions.has(req.params.action)) {
    if (typeof actions.get(req.params.action) === 'function'){
      let action = actions.get(req.params.action);
    }
    // GOOD: `action` is either the `play` or the `pause` function from above
    res.end(action(req.params.payload));
  } else {
    res.end("Unsupported action.");
  }
});
