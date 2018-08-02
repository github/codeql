var express = require('express');
var crypto = require('crypto'),
    password = getPassword();

function encrypt(text){
  var cipher = crypto.createCipher('aes-256-ctr', password);
  return cipher.update(text, 'utf8', 'hex') + cipher.final('hex');
}

var app = express();
app.get('/', function (req, res) {
  let accountName = req.param("AccountName");
  // GOOD: Encoding the value before setting it.
  res.cookie("AccountName", encrypt(accountName));
});
