var express = require('express');

var app = express();
app.enable('x-powered-by').disable('x-powered-by').get('/', function (req, res) {
  let { p } = req.params;
  res.send(p); // NOT OK
});

const prettier = require("prettier");
app.post("foobar", function (reg, res) {
  const code = prettier.format(reg.body, { semi: false, parser: "babel" });
  res.send(code); // NOT OK
});