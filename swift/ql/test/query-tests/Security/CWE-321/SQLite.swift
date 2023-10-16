
// --- stubs ---

enum URIQueryParameter {
}

struct Blob {
	public init(bytes: [UInt8]) { }
	public init(bytes: UnsafeRawPointer, length: Int) { }
}

class Connection {
    enum Location {
        case inMemory
        case uri(String, parameters: [URIQueryParameter] = [])
    }

    init(_ location: Location = .inMemory, readonly: Bool = false) throws { }
    convenience init(_ filename: String, readonly: Bool = false) throws { try self.init() }
}

extension Connection {
	func key(_ key: String, db: String = "main") throws { }
	func key(_ key: Blob, db: String = "main") throws { }
	func keyAndMigrate(_ key: String, db: String = "main") throws { }
	func keyAndMigrate(_ key: Blob, db: String = "main") throws { }

	func rekey(_ key: String, db: String = "main") throws { }
	func rekey(_ key: Blob, db: String = "main") throws { }

	func sqlcipher_export(_ location: Location, key: String) throws { }
}

// --- tests ---

func test_sqlite_swift_api(dbPath: String, goodKey: String, goodArray: [UInt8]) throws {
	let db = try Connection(dbPath)
	let badArray: [UInt8] = [1, 2, 3]

	// methods taking a string key

	try db.key(goodKey)
	try db.key("hardcoded_key") // BAD
	try db.keyAndMigrate(goodKey)
	try db.keyAndMigrate("hardcoded_key") // BAD
	try db.rekey(goodKey)
	try db.rekey("hardcoded_key") // BAD
	try db.sqlcipher_export(Connection.Location.uri("encryptedDb.sqlite3"), key: goodKey)
	try db.sqlcipher_export(Connection.Location.uri("encryptedDb.sqlite3"), key: "hardcoded_key") // BAD

	// Blob variant

	try db.key(Blob(bytes: goodArray))
	try db.key(Blob(bytes: [1, 2, 3])) // BAD [NOT DETECTED]

	try goodArray.withUnsafeBytes { bytes in
		if let ptr = bytes.baseAddress {
			try db.key(Blob(bytes: ptr, length: bytes.count))
		}
	}
	try badArray.withUnsafeBytes { bytes in
		if let ptr = bytes.baseAddress {
			try db.key(Blob(bytes: ptr, length: bytes.count)) // BAD [NOT DETECTED]
		}
	}
}
