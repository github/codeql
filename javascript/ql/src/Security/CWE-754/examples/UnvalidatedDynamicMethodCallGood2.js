var express = require('express');
var app = express();

var actions = {
  play(data) {
    // ...
  },
  pause(data) {
    // ...
  }
}

app.get('/perform/:action/:payload', function(req, res) {
  if (actions.hasOwnProperty(req.params.action)) {
    let action = actions[req.params.action];
    if (typeof action === 'function') {
      // GOOD: `action` is an own method of `actions`
      res.end(action(req.params.payload));
      return;
    }
  }
  res.end("Unsupported action.");
});
