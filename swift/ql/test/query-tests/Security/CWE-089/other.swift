
// --- stubs ---

struct URL
{
	init?(string: String) {}
}

extension String {
	init(contentsOf: URL) throws {
		self.init("")
	}
}

class NSObject {
}

class NSString : NSObject {
    init(string: String) { }
}

class Sql {
}

class MyDatabase {
	init(sql code: String? = nil) { }

	func execute1(_ sql: String) { }
	func execute2(_ sql: String?) { }
	func execute3(_ sql: NSString) { }
	func execute4(_ sql: Sql) { }

	func query(sql: String) { }
	func query(sqlLiteral: String) { }
	func query(sqlStatement: String) { }
	func query(sqliteStatement: String) { }

	// non-examples
	func doSomething(sqlIndex: Int) { }
	func doSomething(sqliteContext: Sql) { }
}

// --- tests ---

func test_heuristic(db: MyDatabase) throws {
	let remoteString = try String(contentsOf: URL(string: "http://example.com/")!)

	_ = MyDatabase() // GOOD
	_ = MyDatabase(sql: "some_fixed_sql") // GOOD
	_ = MyDatabase(sql: remoteString) // BAD

	db.execute1(remoteString) // BAD
	db.execute2(remoteString) // BAD
	db.execute3(NSString(string: remoteString)) // BAD
	db.execute4(remoteString as! Sql) // BAD

	db.query(sql: remoteString) // BAD
	db.query(sqlLiteral: remoteString) // BAD [NOT DETECTED]
	db.query(sqlStatement: remoteString) // BAD [NOT DETECTED]
	db.query(sqliteStatement: remoteString) // BAD [NOT DETECTED]

	db.doSomething(sqlIndex: Int(remoteString) ?? 0) // GOOD
	db.doSomething(sqliteContext: remoteString as! Sql) // GOOD
}
