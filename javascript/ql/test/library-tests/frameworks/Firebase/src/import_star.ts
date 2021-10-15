import * as firebase from "firebase";

function test(db: firebase.database.Database) {
  db.ref("hello");
}
