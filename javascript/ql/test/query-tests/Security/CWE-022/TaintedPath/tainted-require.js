var express = require('express');

var app = express();

app.get('/some/path', function(req, res) {
  // BAD: loading a module based on un-sanitized query parameters
  var m = require(req.param("module"));
});
