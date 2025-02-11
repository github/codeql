var express = require('express');

var app = express();
app.get('/remember-password', function (req, res) {
  let pw = req.param("current_password");
  res.cookie("password", pw); // $ Alert TODO-MISSING: Alert[js/actions/actions-artifact-leak] Alert[js/build-artifact-leak] Alert[js/clear-text-logging] - Setting a cookie value with cleartext sensitive data.
});
