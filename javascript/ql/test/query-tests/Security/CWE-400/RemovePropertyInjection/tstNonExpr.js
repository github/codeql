var http = require('http');
var url = require('url');

var server = http.createServer(function(req, res) {
  var userVal = req.url;
  var newProp = "$" + userVal;  
  x[newProp] = 23; // OK  
  res.setHeader(userVal, 'text/html'); // NOT OK
  res.write("foo");
  res.end("bar");
})