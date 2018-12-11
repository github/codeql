var express = require('express');

var app = express();

app.get('/some/path', function(req, res) {
  // NOT OK
  var f = new Function("return wibbles[" + req.param("wobble") + "];");
  // NOT OK
  require("vm").runInThisContext("return wibbles[" + req.param("wobble") + "];");
  var runC = require("vm").runInNewContext;
  // NOT OK
  runC("return wibbles[" + req.param("wobble") + "];");  
});
