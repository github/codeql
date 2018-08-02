var express = require('express'),
    path = require('path'),
var app = express();

app.get('/user-files', function(req, res) {
    var file = req.param('file');
    if (typeof path !== 'string' || path.indexOf('..') !== -1) { // GOOD
        // forbid paths outside the /public directory
        res.status(400).send('Bad request');
    } else {
        var full = path.resolve('/public/' + file);
        console.log("Sending file: %s", full);
        res.sendFile(full);
    }
});
