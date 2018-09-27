var express = require('express');

var app = express();

app.get('/some/path', function(req, res) {
  // BAD: sending a file based on un-sanitized query parameters
  res.sendFile(req.param("gimme"));
  // BAD: same as above
  res.sendfile(req.param("gimme"));
});
