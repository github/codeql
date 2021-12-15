var express = require("express"),
  fs = require("fs"),
  cp = require("child_process");
var app = express();

(req, res) => 42;

app.get("/some/path", function(req, res) {});

let rh = function(req, res) {};
app.get("/some/other/path", rh);

otherApp.get("/some/other/path", rh);

app.get("/some/path", function(req, res) {
  fs.readFile(req.query.x);
  cp.exec(req.query.x);
  res.send(req.query.x);
});
