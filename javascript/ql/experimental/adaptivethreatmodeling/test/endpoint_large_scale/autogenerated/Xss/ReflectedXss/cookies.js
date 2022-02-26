var express = require('express'),
    cookieParser = require('cookie-parser');

var app = express();
app.use(cookieParser());

app.get('/cookie/:name', function(req, res) {
  // OK
  res.send("Here, have a cookie: " + req.cookies[req.params.name]);
});
