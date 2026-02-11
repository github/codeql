var express = require('express');
var http = require('http')
var app = express()
var server = http.createServer(app)
// Static files:
app.use(express.static(__dirname)) // $ Alert[js/exposure-of-private-files]
