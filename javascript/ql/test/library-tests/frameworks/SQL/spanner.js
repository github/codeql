const { Spanner } = require("@google-cloud/spanner");
const spanner = new Spanner();
const instance = spanner.instance('inst');
const db = instance.database('db');

db.run("SQL code", (err, rows) => {});
db.run({ sql: "SQL code" }, (err, rows) => {});
db.runPartitionedUpdate("SQL code", (err, rows) => {});
db.runPartitionedUpdate({ sql: "SQL code" }, (err, rows) => {});
db.runStream("SQL code");
db.runStream({ sql: "SQL code"});

db.runTransaction((err, tx) => {
  tx.run("SQL code");
  tx.run({ sql: "SQL code" });
  tx.runStream("SQL code");
  tx.runStream({ sql: "SQL code" });
  tx.runUpdate("SQL code");
  tx.runUpdate({ sql: "SQL code" });
});

exports.instance = instance;
