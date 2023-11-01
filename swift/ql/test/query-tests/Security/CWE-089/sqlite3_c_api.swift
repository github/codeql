
// --- stubs ---

struct URL
{
	init?(string: String) {}
	init?(string: String, relativeTo: URL?) {}
}
protocol DataProtocol { }
struct Data : DataProtocol {
	init<S>(_ elements: S) { count = 0 }

	var count: Int

	func copyBytes(to pointer: UnsafeMutablePointer<UInt8>, count: Int) {}
}

extension String {
	init(contentsOf: URL) throws {
		var data = ""

		// ...

		self.init(data)
	}

	struct Encoding {
		var rawValue: UInt

		init(rawValue: UInt) {
			self.rawValue = rawValue
		}

		static let utf16 = Encoding(rawValue: 1)
	}

	func data(using encoding: String.Encoding, allowLossyConversion: Bool = false) -> Data? { return nil }
}

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

func sqlite3_prepare_v2(
		_ db: OpaquePointer?,
		_ zSql: UnsafePointer<CChar>?,
		_ nByte: Int32,
		_ ppStmt: UnsafeMutablePointer<OpaquePointer?>?,
		_ pzTail: UnsafeMutablePointer<UnsafePointer<CChar>?>?
	) -> Int32 { return SQLITE_OK }

func sqlite3_prepare_v3(
		_ db: OpaquePointer?,
		_ zSql: UnsafePointer<CChar>?,
		_ nByte: Int32,
		_ prepFlags: UInt32,
		_ ppStmt: UnsafeMutablePointer<OpaquePointer?>?,
		_ pzTail: UnsafeMutablePointer<UnsafePointer<CChar>?>?
	) -> Int32 { return SQLITE_OK }

func sqlite3_prepare16(
		_ db: OpaquePointer?,
		_ zSql: UnsafeRawPointer?,
		_ nByte: Int32,
		_ ppStmt: UnsafeMutablePointer<OpaquePointer?>?,
		_ pzTail: UnsafeMutablePointer<UnsafeRawPointer?>?
	) -> Int32 { return SQLITE_OK }

func sqlite3_prepare16_v2(
		_ db: OpaquePointer?,
		_ zSql: UnsafeRawPointer?,
		_ nByte: Int32,
		_ ppStmt: UnsafeMutablePointer<OpaquePointer?>?,
		_ pzTail: UnsafeMutablePointer<UnsafeRawPointer?>?
	) -> Int32 { return SQLITE_OK }

func sqlite3_prepare16_v3(
		_ db: OpaquePointer?,
		_ zSql: UnsafeRawPointer?,
		_ nByte: Int32,
		_ prepFlags: UInt32,
		_ ppStmt: UnsafeMutablePointer<OpaquePointer?>?,
		_ pzTail: UnsafeMutablePointer<UnsafeRawPointer?>?
	) -> Int32 { return SQLITE_OK }

func sqlite3_bind_text(
		_ _: OpaquePointer?,
		_ _: Int32,
		_ _: UnsafePointer<CChar>?,
		_ _: Int32,
		_ callback: (@convention(c) (UnsafeMutableRawPointer?) -> Void)?
	) -> Int32 { return SQLITE_OK }
// (many other `sqlite3_bind_*` functions exist)

func sqlite3_step(
		_ _: OpaquePointer?
	) -> Int32 { return SQLITE_OK }

func sqlite3_finalize(
		_ pStmt: OpaquePointer?
	) -> Int32 { return SQLITE_OK }

// --- tests ---

func test_sqlite3_c_api(db: OpaquePointer?, buffer: UnsafeMutablePointer<UInt8>) {
	let localString = "user"
	let remoteString = try! String(contentsOf: URL(string: "http://example.com/")!)
	let remoteNumber = Int(remoteString) ?? 0

	let unsafeQuery1 = remoteString
	let unsafeQuery2 = "SELECT * FROM users WHERE username='" + remoteString + "'"
	let unsafeQuery3 = "SELECT * FROM users WHERE username='\(remoteString)'"
	let safeQuery1 = "SELECT * FROM users WHERE username='\(localString)'"
	let safeQuery2 = "SELECT * FROM users WHERE username='\(remoteNumber)'"

	// --- exec ---

	let result1 = sqlite3_exec(db, unsafeQuery1, nil, nil, nil) // BAD
	let result2 = sqlite3_exec(db, unsafeQuery2, nil, nil, nil) // BAD
	let result3 = sqlite3_exec(db, unsafeQuery3, nil, nil, nil) // BAD
	let result4 = sqlite3_exec(db, safeQuery1, nil, nil, nil) // GOOD
	let result5 = sqlite3_exec(db, safeQuery2, nil, nil, nil) // GOOD

	// --- prepared statements ---

	let varQuery = "SELECT * FROM users WHERE username=?"

	var stmt1: OpaquePointer?

	if (sqlite3_prepare(db, unsafeQuery3, -1, &stmt1, nil) == SQLITE_OK) { // BAD
		let result = sqlite3_step(stmt1)
		// ...
	}
	sqlite3_finalize(stmt1)

	var stmt2: OpaquePointer?

	if (sqlite3_prepare(db, varQuery, -1, &stmt2, nil) == SQLITE_OK) { // GOOD
		if (sqlite3_bind_text(stmt2, 1, localString, -1, SQLITE_TRANSIENT) == SQLITE_OK) { // GOOD
			let result = sqlite3_step(stmt2)
			// ...
		}
	}
	sqlite3_finalize(stmt2)

	var stmt3: OpaquePointer?

	if (sqlite3_prepare(db, varQuery, -1, &stmt3, nil) == SQLITE_OK) { // GOOD
		if (sqlite3_bind_text(stmt3, 1, remoteString, -1, SQLITE_TRANSIENT) == SQLITE_OK) { // GOOD
			let result = sqlite3_step(stmt3)
			// ...
		}
	}
	sqlite3_finalize(stmt3)

	// --- variant 'prepare' functions ---

	var stmt4: OpaquePointer?

	if (sqlite3_prepare_v2(db, unsafeQuery3, -1, &stmt4, nil) == SQLITE_OK) { // BAD
		let result = sqlite3_step(stmt4)
		// ...
	}
	sqlite3_finalize(stmt4)

	var stmt5: OpaquePointer?

	if (sqlite3_prepare_v3(db, unsafeQuery3, -1, 0, &stmt5, nil) == SQLITE_OK) { // BAD
		let result = sqlite3_step(stmt5)
		// ...
	}
	sqlite3_finalize(stmt5)

	let data = unsafeQuery3.data(using:String.Encoding.utf16)!
	data.copyBytes(to: buffer, count: data.count)

	var stmt6: OpaquePointer?

	if (sqlite3_prepare16(db, buffer, Int32(data.count), &stmt6, nil) == SQLITE_OK) { // BAD
		let result = sqlite3_step(stmt6)
		// ...
	}
	sqlite3_finalize(stmt6)

	var stmt7: OpaquePointer?

	if (sqlite3_prepare16_v2(db, buffer, Int32(data.count), &stmt7, nil) == SQLITE_OK) { // BAD
		let result = sqlite3_step(stmt7)
		// ...
	}
	sqlite3_finalize(stmt7)

	var stmt8: OpaquePointer?

	if (sqlite3_prepare16_v3(db, buffer, Int32(data.count), 0, &stmt8, nil) == SQLITE_OK) { // BAD
		let result = sqlite3_step(stmt8)
		// ...
	}
	sqlite3_finalize(stmt8)
}
