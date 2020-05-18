const { instance } = require('./spanner');
const db = instance.database('db');

db.run("SQL code", (err, rows) => {});
