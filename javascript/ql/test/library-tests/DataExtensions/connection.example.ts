import { Connection } from "@example/mysql";

function submit(connection: Connection, q: string) {
  connection.query(q); // <-- add 'q' as a SQL injection sink
}

import { getConnection } from "@example/db";
let connection = getConnection();
connection.query(q); // <-- add 'q' as a SQL injection sink
