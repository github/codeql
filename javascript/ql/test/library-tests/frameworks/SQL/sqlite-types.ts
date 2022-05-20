import { Database } from "sqlite3";

export function doSomething(db: Database) {
    db.run("UPDATE tbl SET name = ? WHERE id = ?", "bar", 2);
}
