var express = require('express');
let path = require('path');

var app = express();

app.get('/some/path/:x', function(req, res) {
  res.sendFile(req.param("gimme")); // $ Alert - sending a file based on un-sanitized query parameters
  res.sendfile(req.param("gimme")); // $ Alert - same as above

  // OK - ensures files cannot be accessed outside of root folder
  res.sendFile(req.param("gimme"), { root: process.cwd() });
  // OK - ensures files cannot be accessed outside of root folder
  res.sendfile(req.param("gimme"), { root: process.cwd() });

  res.sendFile(req.param("file"), { root: req.param("dir") }); // $ Alert - doesn't help if user controls root

  let homeDir = path.resolve('.');
  res.sendFile(homeDir + '/data/' + req.params.x); // OK - sendFile disallows ../
  res.sendfile('data/' + req.params.x); // OK - sendfile disallows ../

  res.sendFile(path.resolve('data', req.params.x)); // $ Alert
  res.sendfile(path.join('data', req.params.x)); // $ Alert

  res.sendFile(homeDir + path.join('data', req.params.x)); // kinda OK - can only escape from 'data/'

  res.download(req.param("gimme")); // $ Alert

  res.download(homeDir + '/data/' + req.params.x); // $ Alert

  res.download(path.join('data', req.params.x)); // $ Alert

  res.download(req.param("file"), { root: req.param("dir") }); // $ Alert

  // OK - ensures files cannot be accessed outside of root folder
  res.download(req.param("gimme"), { root: process.cwd() });
});
