var express = require('express');
var _ = require('lodash');
var app = express();

app.get('/findKey', function(req, res) {
  var key = req.param("key"), input = req.param("input");

  // OK - User input is sanitized before constructing the regex
  var safeKey = _.escapeRegExp(key);
  var re = new RegExp("\\b" + safeKey + "=(.*)\n");
});

var { LinkifyIt } = require("linkify-it");

app.get('/findLinks', function(req, res) {
  var text = req.param("text");
  var scanner = new LinkifyIt().set({ fuzzyLink: false });
  var matches = scanner.match(text);
  res.json(matches);
});
