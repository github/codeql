var express = require('express');
const sql = require('mssql');

var app = express();
app.get('/post/:id', async function(req, res) {
  // OK
  sql.query`select * from mytable where id = ${req.params.id}`;
  // NOT OK
  new sql.Request().query("select * from mytable where id = '" + req.params.id + "'");
});
