var express = require('express');
var app = express();

app.get('/some/path', function(req, res) {
  let { foo, bar: baz } = req.query;
});
