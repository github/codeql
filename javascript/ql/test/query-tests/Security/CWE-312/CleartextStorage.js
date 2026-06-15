var express = require('express');

var app = express();
app.get('/remember-password', function (req, res) {
  let pw = req.param("current_password"); // $ Source[js/clear-text-storage-of-sensitive-data]
  res.cookie("password", pw); // $ Alert[js/clear-text-storage-of-sensitive-data] - Setting a cookie value with cleartext sensitive data.
});
