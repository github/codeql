var express = require('express');
var app = express();

app.param('foo', (req, res, next, value) => {
    console.log(req.query.xx);
    console.log(req.body.xx);
    if (value) {
        res.send(value);
    } else {
        next();
    }
});

app.get('/hello/:foo', function(req, res) {
  res.send("Hello");
});
