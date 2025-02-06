var express = require('express');

var app = express();
app.get('/remember-password', function (req, res) {
  let pw = req.param("current_password");
  res.cookie("password", pw); // $ Alert - Setting a cookie value with cleartext sensitive data.
});
