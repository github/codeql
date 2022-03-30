
var express = require('express');

var app = express();

app.use('/node_modules', express.static(path.resolve(__dirname, '../node_modules')));