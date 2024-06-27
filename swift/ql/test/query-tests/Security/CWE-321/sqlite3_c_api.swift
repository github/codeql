
// --- stubs ---

protocol ContiguousBytes {
	func withUnsafeBytes<R>(_ body: (UnsafeRawBufferPointer) throws -> R) rethrows -> R
}

struct Data : ContiguousBytes {
    init<S>(_ elements: S) { count = 0 }

	func withUnsafeBytes<ResultType>(_ body: (UnsafeRawBufferPointer) throws -> ResultType) rethrows -> ResultType {
		return 0 as! ResultType
	}

	func withUnsafeBytes<ResultType, ContentType>(_ body: (UnsafePointer<ContentType>) throws -> ResultType) rethrows -> ResultType {
		return 0 as! ResultType
	}

	var count: Int
}

var SQLITE_OK : Int32 = 0

func sqlite3_key_v2(
		_ db: OpaquePointer?,
		_ zDbName: UnsafePointer<CChar>?,
		_ pKey: UnsafeRawPointer?,
		_ nKey: Int32
	) -> Int32 { return SQLITE_OK }

func sqlite3_rekey_v2(
		_ db: OpaquePointer?,
		_ zDbName: UnsafePointer<CChar>?,
		_ pKey: UnsafeRawPointer?,
		_ nKey: Int32
	) -> Int32 { return SQLITE_OK }

// --- tests ---

func test_sqlite3_c_api(db: OpaquePointer?, myVarKey: Data) {
	let myConstKey = Data("abcdef123456")

	// SQLite (C API) Encryption Extension
	myVarKey.withUnsafeBytes { buffer in
		_ = sqlite3_key_v2(db, "dbname", buffer, Int32(myVarKey.count))
		_ = sqlite3_rekey_v2(db, "dbname", buffer, Int32(myVarKey.count))
	}
	myConstKey.withUnsafeBytes { buffer in
		_ = sqlite3_key_v2(db, "dbname", buffer, Int32(myVarKey.count)) // BAD
		_ = sqlite3_rekey_v2(db, "dbname", buffer, Int32(myVarKey.count)) // BAD
	}
}
