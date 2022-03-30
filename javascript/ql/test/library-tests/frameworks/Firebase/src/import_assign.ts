import firebase = require("firebase");

function test(db: firebase.database.Database) {
  db.ref("hello");
}
