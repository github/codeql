var express = require('express');

var app = express();
app.enable('x-powered-by').disable('x-powered-by').get('/', function (req, res) {
  let { p } = req.params;
  res.send(p); // NOT OK
});
