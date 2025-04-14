const app = require("express")();
const mysql = require('mysql');
const pool = mysql.createPool(getConfig());

app.get("search", function handler(req, res) {
    let temp = req.params.value; // $ Source
    pool.getConnection(function(err, connection) {
        connection.query({
            sql: 'SELECT * FROM `books` WHERE `author` = ?',
            values: [temp]
        }, function(error, results, fields) {});
    });
    pool.getConnection(function(err, connection) {
        connection.query({
            sql: 'SELECT * FROM `books` WHERE `author` = ' + temp, // $ Alert
        }, function(error, results, fields) {});
    });
    pool.getConnection(function(err, connection) {
        connection.query('SELECT * FROM `books` WHERE `author` = ' + temp, // $ Alert
            function(error, results, fields) {});
    });
});
