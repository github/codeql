var express = require('express');

var app = express();
app.enable('x-powered-by').disable('x-powered-by').get('/', function (req, res) {
  let { p } = req.params; // $ Source
  res.send(p); // $ Alert
});

const prettier = require("prettier");
app.post("foobar", function (reg, res) {
  const code = prettier.format(reg.body, { semi: false, parser: "babel" }); // $ Source
  res.send(code); // $ Alert
});