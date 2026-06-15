
var express = require('express');
var path = require("path");

var app = express();

app.use('basedir', express.static(__dirname)); // $ Alert[js/exposure-of-private-files]
const rootDir = __dirname;
app.use('basedir', express.static(rootDir)); // $ Alert[js/exposure-of-private-files]

app.use('/monthly', express.static(__dirname + '/')); // $ Alert[js/exposure-of-private-files]