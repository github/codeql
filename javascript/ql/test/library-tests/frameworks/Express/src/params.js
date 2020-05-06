var express = require('express');
var app = express();

app.param('foo', (req, res, next, value) => {
    if (value) {
        res.send(value);
    } else {
        next();
    }
});

app.get('/hello/:foo', function(req, res) {
  res.send("Hello");
});
