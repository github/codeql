import Database from 'better-sqlite3';

const db = new Database('BetterSqlite.db', { verbose: console.log });

let sql = 'SELECT name, id FROM table1'
let stmt = db.prepare(sql);
let exec = db.exec(sql);
exec.prepare(sql)
const db2 = Database('BetterSqlite.db', { verbose: console.log });

sql = 'SELECT name, id FROM table1'
stmt = db2.prepare(sql);
exec = db2.exec(sql);
exec.prepare(sql)
