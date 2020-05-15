// Adapted from https://github.com/mapbox/node-sqlite3/wiki/API, which is
// part of the node-sqlite3 project, which is licensed under the BSD 3-Clause
// License; see file node-sqlite3-LICENSE.
var sqlite = require('sqlite3');

var db = new sqlite.Database(":memory:");
db.run("UPDATE tbl SET name = ? WHERE id = ?", "bar", 2);

exports.db = db;
