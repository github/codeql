const express = require('express');
var app = express();

function getHandler() {
    return function(req, res) {};
}

var handler = getHandler();
app.use(handler);

