import type { VercelRequest, VercelResponse } from "@vercel/node";
const mysql = require("mysql");
const conn = mysql.createConnection({});

export default function handler(req: VercelRequest, res: VercelResponse) {
  const id = req.query.id as string; // $ Source
  conn.query("SELECT * FROM users WHERE id = " + id, (err: any, rows: any) => { // $ Alert
    res.json(rows);
  });
}
