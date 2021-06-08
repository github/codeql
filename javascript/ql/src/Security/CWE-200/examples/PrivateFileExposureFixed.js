
var express = require('express');

var app = express();

app.use("jquery", express.static('./node_modules/jquery/dist'));
app.use("bootstrap", express.static('./node_modules/bootstrap/dist'));