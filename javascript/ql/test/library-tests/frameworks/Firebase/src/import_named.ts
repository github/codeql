import { database } from "firebase";

function test(db: database.Database) {
  db.ref("hello");
}
