
var express = require('express');
var path = require("path");

var app = express();

app.use('basedir', express.static(__dirname)); // $ Alert TODO-MISSING: Alert[js/file-access-to-http]
const rootDir = __dirname;
app.use('basedir', express.static(rootDir)); // $ Alert TODO-MISSING: Alert[js/file-access-to-http]

app.use('/monthly', express.static(__dirname + '/')); // $ Alert TODO-MISSING: Alert[js/file-access-to-http]