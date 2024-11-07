// with SQLite.swift

let unsafeQuery = "SELECT * FROM users WHERE username='\(userControlledString)'"

try db.execute(unsafeQuery) // BAD

let stmt = try db.prepare(unsafeQuery) // also BAD
try stmt.run()

// with SQLite3 C API

let result = sqlite3_exec(db, unsafeQuery, nil, nil, nil) // BAD
