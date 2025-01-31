var express = require('express');

var app = express();

app.get('/some/path', function(req, res) {
  var m = require(req.param("module")); // $ Alert - loading a module based on un-sanitized query parameters
});

const resolve = require("resolve");
app.get('/some/path', function(req, res) {
  var module = resolve.sync(req.param("module")); // $ Alert - resolving module based on query parameters

  resolve(req.param("module"), { basedir: __dirname }, function(err, res) { // $ Alert - resolving module based on query parameters
    var module = res;
  });
});