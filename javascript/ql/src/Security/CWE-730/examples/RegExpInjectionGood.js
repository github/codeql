var express = require('express');
var _ = require('lodash');
var app = express();

app.get('/findKey', function(req, res) {
  var key = req.param("key"), input = req.param("input");

  // GOOD: User input is sanitized before constructing the regex
  var safeKey = _.escapeRegExp(key);
  var re = new RegExp("\\b" + safeKey + "=(.*)\n");
});
