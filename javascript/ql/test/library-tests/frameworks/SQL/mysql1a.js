// Adapted from the documentation of https://github.com/mysqljs/mysql,
// which is licensed under the MIT license; see file mysqljs-License.

function importMySql() {
  return require("mysql");
}

var connection = importMySql().createConnection({
  host: 'localhost',
  user: 'me',
  password: 'secret',
  database: 'my_db'
});

connection.connect();

connection.query('SELECT 1 + 1 AS solution', function (error, results, fields) {
  if (error) throw error;
  console.log('The solution is: ', results[0].solution);
});

connection.end();

exports.connection = connection;
