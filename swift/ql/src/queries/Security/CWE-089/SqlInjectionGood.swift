let safeQuery = "SELECT * FROM users WHERE username=?"

let stmt = try db.prepare(safeQuery, userControlledString) // GOOD
try stmt2.run()