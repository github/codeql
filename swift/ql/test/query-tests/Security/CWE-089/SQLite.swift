
// --- stubs ---

public protocol Binding {}

extension String: Binding {}

class Statement {
	init(_ connection: Connection, _ SQL: String) throws {}

	public func bind(_ values: Binding?...) -> Statement { return Statement() }
	public func bind(_ values: [Binding?]) -> Statement { return Statement() }
	public func bind(_ values: [String: Binding?]) -> Statement { return Statement() }

	@discardableResult public func run(_ bindings: Binding?...) throws -> Statement { return Statement() }
	@discardableResult public func run(_ bindings: [Binding?]) throws -> Statement { return Statement() }
	@discardableResult public func run(_ bindings: [String: Binding?]) throws -> Statement { return Statement() }

	public func scalar(_ bindings: Binding?...) throws -> Binding? { return Binding() }
	public func scalar(_ bindings: [Binding?]) throws -> Binding? { return Binding() }
	public func scalar(_ bindings: [String: Binding?]) throws -> Binding? { return Binding() }
}

class Connection {
	public func execute(_ SQL: String) throws { }

	public func prepare(_ statement: String, _ bindings: Binding?...) throws -> Statement { return Statement() }
	public func prepare(_ statement: String, _ bindings: [Binding?]) throws -> Statement { return Statement() }
	public func prepare(_ statement: String, _ bindings: [String: Binding?]) throws -> Statement { return Statement() }

	@discardableResult public func run(_ statement: String, _ bindings: Binding?...) throws -> Statement { return Statement() }
	@discardableResult public func run(_ statement: String, _ bindings: [Binding?]) throws -> Statement { return Statement() }
	@discardableResult public func run(_ statement: String, _ bindings: [String: Binding?]) throws -> Statement { return Statement() }

	public func scalar(_ statement: String, _ bindings: Binding?...) throws -> Binding? { return Binding() }
	public func scalar(_ statement: String, _ bindings: [Binding?]) throws -> Binding? { return Binding() }
	public func scalar(_ statement: String, _ bindings: [String: Binding?]) throws -> Binding? { return Binding() }
}

// --- tests ---

func test_sqlite_swift_api(db: Connection) {
	let localString = "user"
	let remoteString = try! String(contentsOf: URL(string: "http://example.com/")!)
	let remoteNumber = Int(remoteString) ?? 0

	let unsafeQuery1 = remoteString
	let unsafeQuery2 = "SELECT * FROM users WHERE username='" + remoteString + "'"
	let unsafeQuery3 = "SELECT * FROM users WHERE username='\(remoteString)'"
	let safeQuery1 = "SELECT * FROM users WHERE username='\(localString)'"
	let safeQuery2 = "SELECT * FROM users WHERE username='\(remoteNumber)'"
	let varQuery = "SELECT * FROM users WHERE username=?"

	// --- execute ---

	try db.execute(unsafeQuery1) // BAD
	try db.execute(unsafeQuery2) // BAD
	try db.execute(unsafeQuery3) // BAD
	try db.execute(safeQuery1) // GOOD
	try db.execute(safeQuery2) // GOOD

	// --- prepared statements ---

	let stmt1 = try db.prepare(unsafeQuery3) // BAD
	try stmt1.run()

	let stmt2 = try db.prepare(varQuery, localString) // GOOD
	try stmt2.run()

	let stmt3 = try db.prepare(varQuery, remoteString) // GOOD
	try stmt3.run()

	// TODO: test all versions of prepare, run, scalar on Connection and Statement
}
