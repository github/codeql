// Adapted from https://github.com/mapbox/node-sqlite3/wiki/API, which is
// part of the node-sqlite3 project, which is licensed under the BSD 3-Clause
// License; see file node-sqlite3-LICENSE.
var express = require('express');
var sqlite3 = require('sqlite3').verbose();
var db = new sqlite3.Database(':memory:');

var app = express();
app.get('/post/:id', function(req, res) {
  db.get('SELECT * FROM Post WHERE id = "' + req.params.id + '"');
});
