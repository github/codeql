import Database from 'better-sqlite3';
const db = new Database('BetterSqlite.db', { verbose: console.log });

const sql = 'SELECT name, id FROM table1'
const stmt = db.prepare(sql);
let exec = db.exec(sql);
exec.prepare(sql)