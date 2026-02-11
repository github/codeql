const mysql = require('mysql');
const pool = mysql.createPool(getConfig());

let temp = process.env['foo']; // $ Source
pool.getConnection(function(err, connection) {
    connection.query({
        sql: 'SELECT * FROM `books` WHERE `author` = ' + temp, // $ Alert
    }, function(error, results, fields) {});
});
