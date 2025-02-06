
var express = require('express');
var path = require("path");

var app = express();

app.use('basedir', express.static(__dirname)); // $ Alert
const rootDir = __dirname;
app.use('basedir', express.static(rootDir)); // $ Alert

app.use('/monthly', express.static(__dirname + '/')); // $ Alert