
var express = require('express');
var path = require("path");

var app = express();

app.use('basedir', express.static(__dirname)); // BAD
const rootDir = __dirname;
app.use('basedir', express.static(rootDir)); // BAD

app.use('/monthly', express.static(__dirname + '/')); // BAD