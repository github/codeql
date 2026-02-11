var express = require('express');
var app = express();

app.get('/test-environment', function(req, res) {
  // Environment variables should be detected when "environment" threat model is enabled
  new RegExp(`^${process.env.HOME}/Foo/bar.app$`); // $ Alert[js/regex-injection]
  
  new RegExp(`^${process.env.PATH}/bin$`); // $ Alert[js/regex-injection]
  
  var envVar = process.env.NODE_ENV; // $ Source[js/regex-injection]
  new RegExp(envVar); // $ Alert[js/regex-injection]
  
  // Command line arguments should still be detected
  new RegExp(`^${process.argv[1]}/Foo/bar.app$`); // $ Alert[js/regex-injection]
  
  var argv = process.argv[2]; // $ Source[js/regex-injection]
  new RegExp(argv); // $ Alert[js/regex-injection]
  
  // Regular user input should still be detected
  var userInput = req.param("input"); // $ Source[js/regex-injection]
  new RegExp(userInput); // $ Alert[js/regex-injection]
});
