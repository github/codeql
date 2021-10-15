const express = require('express');
var app = express();

var importedGetter = require('./exported-getter').getter;
var handler = importedGetter();
app.use(handler);
