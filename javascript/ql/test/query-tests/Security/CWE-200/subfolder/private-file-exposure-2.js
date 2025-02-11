var express = require('express');
var http = require('http')
var app = express()
var server = http.createServer(app)
// Static files:
app.use(express.static(__dirname)) // $ TODO-SPURIOUS: Alert[js/exposure-of-private-files]
