var express = require('express');
var app = express();

app.get('/some/path', function(req, res) {
  res.render('template-path', {
    timezone: 'UTC'
  });
  res.send('done');
});

app.get('/some/path', function(req, res) {
    req.param("p1");
    req.params.p2;
    req.query.p3;
    req.body;
    req.url;
    req.originalUrl;
    req.get();
    req.header();
    req.cookies;
});
