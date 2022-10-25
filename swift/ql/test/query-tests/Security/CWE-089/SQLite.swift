
// --- stubs ---

struct URL
{
	init?(string: String) {}
	init?(string: String, relativeTo: URL?) {}
}

extension String {
	init(contentsOf: URL) throws {
		var data = ""

		// ...

		self.init(data)
	}
}

public protocol Binding {}

extension String: Binding {}

class Statement {
	fileprivate let connection: Connection

	init(_ connection: Connection, _ SQL: String) throws { self.connection = connection}

	public func bind(_ values: Binding?...) -> Statement { return self }
	public func bind(_ values: [Binding?]) -> Statement { return self }
	public func bind(_ values: [String: Binding?]) -> Statement { return self }

	@discardableResult public func run(_ bindings: Binding?...) throws -> Statement { return self }
	@discardableResult public func run(_ bindings: [Binding?]) throws -> Statement { return self }
	@discardableResult public func run(_ bindings: [String: Binding?]) throws -> Statement { return self }

	public func scalar(_ bindings: Binding?...) throws -> Binding? { return nil }
	public func scalar(_ bindings: [Binding?]) throws -> Binding? { return nil }
	public func scalar(_ bindings: [String: Binding?]) throws -> Binding? { return nil }
}

class Connection {
	public func execute(_ SQL: String) throws { }

	public func prepare(_ statement: String, _ bindings: Binding?...) throws -> Statement { return try Statement(self, "") }
	public func prepare(_ statement: String, _ bindings: [Binding?]) throws -> Statement { return try Statement(self, "") }
	public func prepare(_ statement: String, _ bindings: [String: Binding?]) throws -> Statement { return try Statement(self, "") }

	@discardableResult public func run(_ statement: String, _ bindings: Binding?...) throws -> Statement { return try Statement(self, "") }
	@discardableResult public func run(_ statement: String, _ bindings: [Binding?]) throws -> Statement { return try Statement(self, "") }
	@discardableResult public func run(_ statement: String, _ bindings: [String: Binding?]) throws -> Statement { return try Statement(self, "") }

	public func scalar(_ statement: String, _ bindings: Binding?...) throws -> Binding? { return nil }
	public func scalar(_ statement: String, _ bindings: [Binding?]) throws -> Binding? { return nil }
	public func scalar(_ statement: String, _ bindings: [String: Binding?]) throws -> Binding? { return nil }
}

// --- tests ---

func test_sqlite_swift_api(db: Connection) throws {
	let localString = "user"
	let remoteString = try String(contentsOf: URL(string: "http://example.com/")!)
	let remoteNumber = Int(remoteString) ?? 0

	let unsafeQuery1 = remoteString
	let unsafeQuery2 = "SELECT * FROM users WHERE username='" + remoteString + "'"
	let unsafeQuery3 = "SELECT * FROM users WHERE username='\(remoteString)'"
	let safeQuery1 = "SELECT * FROM users WHERE username='\(localString)'"
	let safeQuery2 = "SELECT * FROM users WHERE username='\(remoteNumber)'"

	// --- execute ---

	try db.execute(unsafeQuery1) // BAD
	try db.execute(unsafeQuery2) // BAD
	try db.execute(unsafeQuery3) // BAD
	try db.execute(safeQuery1) // GOOD
	try db.execute(safeQuery2) // GOOD

	// --- prepared statements ---

	let varQuery = "SELECT * FROM users WHERE username=?"

	let stmt1 = try db.prepare(unsafeQuery3) // BAD
	try stmt1.run()

	let stmt2 = try db.prepare(varQuery, localString) // GOOD
	try stmt2.run()

	let stmt3 = try db.prepare(varQuery, remoteString) // GOOD
	try stmt3.run()

	let stmt4 = try Statement(db, localString) // GOOD
	try stmt4.run()

	let stmt5 = try Statement(db, remoteString) // BAD
	try stmt5.run()

	// --- more variants ---

	let stmt6 = try db.prepare(unsafeQuery1, "") // BAD
	try stmt6.run()

	let stmt7 = try db.prepare(unsafeQuery1, [""]) // BAD
	try stmt7.run()

	let stmt8 = try db.prepare(unsafeQuery1, ["username": ""]) // BAD
	try stmt8.run()

	try db.run(unsafeQuery1, "") // BAD

	try db.run(unsafeQuery1, [""]) // BAD

	try db.run(unsafeQuery1, ["username": ""]) // BAD

	try db.scalar(unsafeQuery1, "") // BAD

	try db.scalar(unsafeQuery1, [""]) // BAD

	try db.scalar(unsafeQuery1, ["username": ""]) // BAD

	let stmt9 = try db.prepare(varQuery) // GOOD
	try stmt9.bind(remoteString) // GOOD
	try stmt9.bind([remoteString]) // GOOD
	try stmt9.bind(["username": remoteString]) // GOOD
	try stmt9.run(remoteString) // GOOD
	try stmt9.run([remoteString]) // GOOD
	try stmt9.run(["username": remoteString]) // GOOD
	try stmt9.scalar(remoteString) // GOOD
	try stmt9.scalar([remoteString]) // GOOD
	try stmt9.scalar(["username": remoteString]) // GOOD

	try Statement(db, remoteString).run() // BAD
}
