// Adapted from the documentation of https://github.com/mysqljs/mysql,
// which is licensed under the MIT license; see file mysqljs-License.
var mysql = require('mysql');
var pool  = mysql.createPool({
    connectionLimit : 10,
    host            : 'example.org',
    user            : 'bob',
    password        : 'secret',
    database        : 'my_db'
});
 
pool.getConnection(function(err, connection) {
  // Use the connection 
  connection.query('SELECT something FROM sometable', function (error, results, fields) {
    // And done with the connection. 
    connection.release();
 
    // Handle error after the release. 
    if (error) throw error;
 
    // Don't use the connection here, it has been returned to the pool. 
  });
});
