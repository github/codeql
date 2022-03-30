const sql = require('mssql');
 
sql.connect({
  user: 'username',
  password: 'password',
  server: 'localhost',
  database: 'database'
});

const pool = new sql.ConnectionPool({
  user: 'username',
  password: 'password',
  server: 'localhost',
  database: 'database'
});
