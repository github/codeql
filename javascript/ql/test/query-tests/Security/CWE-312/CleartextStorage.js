var express = require('express');

var app = express();
app.get('/', function (req, res) {
  let a = req.param("AccountName");
  // BAD: Setting a cookie value with cleartext sensitive data.
  res.cookie("AccountName", a);
});
