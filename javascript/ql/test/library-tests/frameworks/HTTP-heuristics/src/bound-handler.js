const express = require('express');
var app = express();

function handler(req, res){}
var boundHandler = handler.bind(x);
app.use(boundHandler);

function getHandler () {
    return function(req, res){};
}
var boundHandler = getHandler().bind(x);
app.use(boundHandler);
