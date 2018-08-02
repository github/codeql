var express = require('express');

var app = express();

app.get('/user/:id', function(req, res) {
  let { p, q: r } = req.params;
  res.send(p);
  res.send(r);
});
