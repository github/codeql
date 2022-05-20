var express = require('express'),
    Module = require('module');

var app = express();

app.get('/some/path', function (req, res) {
    let filename = req.query.filename;
    var m = new Module(filename, module.parent);
    m._compile(req.query.code, filename); // NOT OK
    var m2 = new module.constructor;
    m2._compile(req.query.code, filename); // NOT OK
});
