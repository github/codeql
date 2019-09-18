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
  let action = actions[req.params.action];
  res.end(action(req.params.payload));
});
