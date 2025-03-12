var http = require('http');
var url = require('url');

var server = http.createServer(function(req, res) {
  var userVal = req.url; // $ Source
  var newProp = "$" + userVal;  
  x[newProp] = 23;
  res.setHeader(userVal, 'text/html'); // $ Alert
  res.write("foo");
  res.end("bar");
})