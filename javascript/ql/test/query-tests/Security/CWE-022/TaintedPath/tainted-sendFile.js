var express = require('express');
let path = require('path');

var app = express();

app.get('/some/path/:x', function(req, res) {
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

  let homeDir = path.resolve('.');
  res.sendFile(homeDir + '/data/' + req.params.x); // OK: sendFile disallows ../
  res.sendfile('data/' + req.params.x); // OK: sendfile disallows ../

  res.sendFile(path.resolve('data', req.params.x)); // NOT OK
  res.sendfile(path.join('data', req.params.x)); // NOT OK

  res.sendFile(homeDir + path.join('data', req.params.x)); // kinda OK - can only escape from 'data/'
});
