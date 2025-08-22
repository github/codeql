var express = require('express');
var app = express();

app.get('/some/path', function(req, res) {
  res.header(req.param("header"), req.param("val"));
  res.send("val");
});

function getHandler() {
    return function (req, res){}
}
app.use(getHandler());

function getHandler2() {
  return function (req, res){}
}
app.use([getHandler2()]);

function handler3(req, res) {}
let array = [handler3];
app.use(array);
