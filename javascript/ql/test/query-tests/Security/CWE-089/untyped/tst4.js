// Adapted from https://github.com/mapbox/node-sqlite3/wiki/API, which is
// part of the node-sqlite3 project, which is licensed under the BSD 3-Clause
var sqlite3 = require('sqlite3').verbose();
var db = new sqlite3.Database(':memory:');

angular.module('myApp', ['ngRoute'])
.controller('FindPost', function($routeParams) {
  db.get('SELECT * FROM Post WHERE id = "' + $routeParams.id + '"');
});
