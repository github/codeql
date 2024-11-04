const mysql = require('mysql');
const pool = mysql.createPool(getConfig());

let temp = process.env['foo'];
pool.getConnection(function(err, connection) {
    connection.query({
        sql: 'SELECT * FROM `books` WHERE `author` = ' + temp, // NOT OK
    }, function(error, results, fields) {});
});
