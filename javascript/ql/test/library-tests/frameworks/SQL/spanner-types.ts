import { Database } from "@google-cloud/spanner";

export function doSomething(db: Database) {
    db.run('SELECT 123');
}
