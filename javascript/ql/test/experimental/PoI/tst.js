var express = require("express");
var app = express();

(req, res) => 42;

app.get("/some/path", function(req, res) {});

let rh = function(req, res) {};
app.get("/some/other/path", rh);

otherApp.get("/some/other/path", rh);
