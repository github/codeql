var express = require('express');

express().get('/user/', function(req, res) {
    var evil = req.query.evil;
    res.send(console.log("<div>%s</div>", evil)); // OK (returns undefined)
    res.send(util.format("<div>%s</div>", evil)); // NOT OK
    res.send(require("printf")("<div>%s</div>", evil)); // NOT OK
});
