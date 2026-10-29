const express = require('express');
var app = express();

function Handler() {
    return function(req, res) {};
}

var handler = new Handler();
app.use(handler);
