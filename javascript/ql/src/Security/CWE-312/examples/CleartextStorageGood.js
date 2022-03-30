var express = require('express');
var crypto = require('crypto'),
    password = getPassword();

function encrypt(text){
  var cipher = crypto.createCipher('aes-256-ctr', password);
  return cipher.update(text, 'utf8', 'hex') + cipher.final('hex');
}

var app = express();
app.get('/remember-password', function (req, res) {
  let pw = req.param("current_password");
  // GOOD: Encoding the value before setting it.
  res.cookie("password", encrypt(pw));
});
