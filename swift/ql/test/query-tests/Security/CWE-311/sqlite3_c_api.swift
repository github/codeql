
// --- stubs ---

var SQLITE_OK : Int32 = 0
var SQLITE_TRANSIENT : (@convention(c) (UnsafeMutableRawPointer?) -> Void)?

func sqlite3_exec(
		_ _: OpaquePointer?,
		_ sql: UnsafePointer<CChar>?,
		_ callback: (@convention(c) (UnsafeMutableRawPointer?, Int32, UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>?, UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>?) -> Int32)?,
		_ _: UnsafeMutableRawPointer?,
		_ errmsg: UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>?
	) -> Int32 { return SQLITE_OK }

func sqlite3_prepare(
		_ db: OpaquePointer?,
		_ zSql: UnsafePointer<CChar>?,
		_ nByte: Int32,
		_ ppStmt: UnsafeMutablePointer<OpaquePointer?>?,
		_ pzTail: UnsafeMutablePointer<UnsafePointer<CChar>?>?
	) -> Int32 { return SQLITE_OK }

func sqlite3_bind_int(
		_ _: OpaquePointer?,
		_ _: Int32,
		_ _: Int32
	) -> Int32 { return SQLITE_OK }

func sqlite3_bind_text(
		_ _: OpaquePointer?,
		_ _: Int32,
		_ _: UnsafePointer<CChar>?,
		_ _: Int32,
		_ callback: (@convention(c) (UnsafeMutableRawPointer?) -> Void)?
	) -> Int32 { return SQLITE_OK }

// --- tests ---

func test_sqlite3_c_api(db: OpaquePointer?, id: Int32, medicalNotes: String) {
	// --- sensitive data in SQL (in practice these cases may also be SQL injection) ---

	let insertQuery = "INSERT INTO PATIENTS(ID, NOTES) VALUES(\(id), \(medicalNotes));"
	let updateQuery = "UPDATE PATIENTS SET NOTES=\(medicalNotes) WHERE ID=\(id);"
	let deleteQuery = "DELETE FROM PATIENTS WHERE ID=\(id);"

	let _ = sqlite3_exec(db, insertQuery, nil, nil, nil) // BAD (sensitive data)
	let _ = sqlite3_exec(db, updateQuery, nil, nil, nil) // BAD (sensitive data)
	let _ = sqlite3_exec(db, deleteQuery, nil, nil, nil) // GOOD

	// --- sensitive data in bindings ---

	let varQuery = "UPDATE PATIENTS SET NOTES=? WHERE ID=?;"

	var stmt1: OpaquePointer?

	if (sqlite3_prepare(db, varQuery, -1, &stmt1, nil) == SQLITE_OK) { // GOOD
		if (sqlite3_bind_int(stmt1, 1, id) == SQLITE_OK) { // GOOD
			if (sqlite3_bind_text(stmt1, 2, medicalNotes, -1, SQLITE_TRANSIENT) == SQLITE_OK) { // BAD (sensitive data)
				// ...
			}
		}
	}
}
