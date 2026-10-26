const express = require('express');
var app = express();

var importedHandler = require('./exported-handler').handler;
app.use(importedHandler);
