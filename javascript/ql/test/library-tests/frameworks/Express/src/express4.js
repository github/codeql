var express = require('express');
var app = express();

app.get('/some/path', function(req, res) {
  let { foo, bar: baz } = req.query;
  let dynamic1 = req.query[foo];
  let dynamic2 = req.query[something()];
  res.send(dynamic1);
});
