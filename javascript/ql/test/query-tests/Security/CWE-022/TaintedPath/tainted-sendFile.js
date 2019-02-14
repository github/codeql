var express = require('express');

var app = express();

app.get('/some/path', function(req, res) {
  // BAD: sending a file based on un-sanitized query parameters
  res.sendFile(req.param("gimme"));
  // BAD: same as above
  res.sendfile(req.param("gimme"));

  // GOOD: ensures files cannot be accessed outside of root folder
  res.sendFile(req.param("gimme"), { root: process.cwd() });
  // GOOD: ensures files cannot be accessed outside of root folder
  res.sendfile(req.param("gimme"), { root: process.cwd() });

  // BAD: doesn't help if user controls root
  res.sendFile(req.param("file"), { root: req.param("dir") });
});
