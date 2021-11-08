var express = require('express');

var app = express();
const fancyLog = require("fancy-log");
app.get('/remember-password', function (req, res) {
  let pw = req.param("current_password");
  
  fancyLog("password: " + pw); // NOT OK
});

var https = require('https');
var url = require('url');

var server = https.createServer(function(req, res) {
  let pw = url.parse(req.url, true).query.current_password;
  
  console.log("password: " + pw); // NOT OK
});

console.log(data.password); // NOT OK
