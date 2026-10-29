var express = require('express');
var app = express();

app.get('/some/path', function(req, res1) {
    res1
});
app.get('/some/path', function(req, res2, next) {
    res2;
});
app.get('/some/path', function(error, req, res3, next) {
    res3;
});
app.get('/some/path', function(req, res4, next, unknown, unknown) {
    res4;
});
app.post('/some/other/path', function(req, res) {
    req.clearCookie();

    res.append();
    res.attachment();
    res.clearCookie();
    res.contentType();
    res.cookie();
    res.format();
    res.header();
    res.links();
    res.location();
    res.send();
    res.sendStatus();
    res.set();
    res.status();
    res.type();
    res.vary();

    res.status().send();

    f(res.append()).append();

    function f(resArg) {
        return resArg.append();
    }
});
