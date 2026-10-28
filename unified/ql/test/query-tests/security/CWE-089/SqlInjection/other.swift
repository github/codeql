
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
	func execute5(_ context: String, _ sql: String) { }
	func execute6(context: String, _ sql: String) { }
	func queryCode(code sql: String) { }
	func queryCode2(sql code: String) { }

	func query(sql: String) { }
	func query(sqlLiteral: String) { }
	func query(sqlStatement: String) { }
	func query(sqliteStatement: String) { }
	func query(config: String, sql: String) { }

	// non-examples
	func doSomething(sqlIndex: Int) { }
	func doSomething(sqliteContext: Sql) { }
}

// --- tests ---

func test_heuristic(db: MyDatabase) throws {
	let remoteString = try String(contentsOf: URL(string: "http://example.com/")!) // $ Source

	_ = MyDatabase() // GOOD
	_ = MyDatabase(sql: "some_fixed_sql") // GOOD
	_ = MyDatabase(sql: remoteString) // $ Alert

	db.execute1(remoteString) // $ Alert
	db.execute2(remoteString) // $ Alert
	db.execute3(NSString(string: remoteString)) // $ Alert
	db.execute4(remoteString as! Sql) // $ Alert

	db.execute5("context", remoteString) // $ Alert
	db.execute5(remoteString, "SELECT 1") // GOOD
	db.execute6(context: "context", remoteString) // $ Alert
	db.execute6(context: remoteString, "SELECT 1") // GOOD

	db.queryCode(code: remoteString) // $ Alert
	db.queryCode(code: "SELECT 1") // GOOD
	db.queryCode2(sql: remoteString) // $ Alert
	db.queryCode2(sql: "SELECT 1") // GOOD

	db.query(sql: remoteString) // $ Alert
	db.query(sqlLiteral: remoteString) // $ MISSING: Alert
	db.query(sqlStatement: remoteString) // $ MISSING: Alert
	db.query(sqliteStatement: remoteString) // $ MISSING: Alert
	db.query(config: "config", sql: remoteString) // $ Alert
	db.query(config: remoteString, sql: "SELECT 1") // GOOD

	db.doSomething(sqlIndex: Int(remoteString) ?? 0) // GOOD
	db.doSomething(sqliteContext: remoteString as! Sql) // GOOD
}
