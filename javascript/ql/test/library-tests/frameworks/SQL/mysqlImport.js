const { connection } = require("./mysql1");

connection.query({
    sql: 'SELECT * FROM `books` WHERE `author` = ?',
}, function (error, results, fields) {
});
