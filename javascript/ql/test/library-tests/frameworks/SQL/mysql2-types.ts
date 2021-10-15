import { Connection } from "mysql2";

export function doSomething(conn: Connection) {
    conn.query('SELECT * FROM users');
}
