var express = require('express');
var app = express();

app.get('/:path', function(req, res) {
  let path = req.params.path;
  if (isValidPath(path))
    res.sendFile(path);
});

function f1(req, res) {
  let path = req.params.path;
  if (isValidPath(path))
    res.sendFile(path);
}

function f2(req, res) {
}

function f3(req, res) {
  let path = req.params.path;
  if (isValidPath(path))
    res.sendFile(path);
}

app.get('/:path', f1, f2, f3);
