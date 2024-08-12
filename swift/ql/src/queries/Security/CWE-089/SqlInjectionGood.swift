// with SQLite.swift

let safeQuery = "SELECT * FROM users WHERE username=?"

let stmt = try db.prepare(safeQuery, userControlledString) // GOOD
try stmt.run()

// with sqlite3 C API

var stmt2: OpaquePointer?

if (sqlite3_prepare_v2(db, safeQuery, -1, &stmt2, nil) == SQLITE_OK) {
	if (sqlite3_bind_text(stmt2, 1, userControlledString, -1, SQLITE_TRANSIENT) == SQLITE_OK) { // GOOD
		let result = sqlite3_step(stmt2)

		// ...
	}
	sqlite3_finalize(stmt2)
}
