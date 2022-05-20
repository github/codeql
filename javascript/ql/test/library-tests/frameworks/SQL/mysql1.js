// Adapted from the documentation of https://github.com/mysqljs/mysql,
// which is licensed under the MIT license; see file mysqljs-License.
var mysql      = require('mysql');
var connection = mysql.createConnection({
  host     : 'localhost',
  user     : 'me',
  password : 'secret',
  database : 'my_db'
});
 
connection.connect();
 
connection.query('SELECT 1 + 1 AS solution', function (error, results, fields) {
  if (error) throw error;
  console.log('The solution is: ', results[0].solution);
});

connection.query({
    sql: 'SELECT * FROM `books` WHERE `author` = ?',
    timeout: 40000, // 40s 
    values: ['David']
}, function (error, results, fields) {
    // error will be an Error if one occurred during the query 
    // results will contain the results of the query 
    // fields will contain information about the returned results fields (if any) 
});
 
connection.end();

exports.connection = connection;
