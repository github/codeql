var express = require('express');
var attacher = require('./exported-middleware-attacher');

var app = express();
attacher(app);
