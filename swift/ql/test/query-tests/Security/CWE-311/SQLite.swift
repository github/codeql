
// --- stubs ---

public protocol Binding {}

public protocol Number: Binding {}

extension String: Binding {}

extension Int: Number {}

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

protocol QueryType { }

protocol SchemaType: QueryType { }

struct Table: SchemaType {
	init(_ name: String, database: String? = nil) { }
}

protocol ExpressionType : CustomStringConvertible {
	init(_ template: String, _ bindings: [Binding?])
}

extension ExpressionType {
	init(_ identifier: String) {
		self.init(identifier, [])
	}

	var description: String { get { "" } }
}

extension ExpressionType { // where UnderlyingType == String
	public func replace(_ pattern: String, with replacement: String) -> Expression<String> {
		return Expression<String>("")
	}
}

struct Expression<Datatype> : ExpressionType {
	typealias UnderlyingType = Datatype

	init(_ template: String, _ bindings: [Binding?]) { }
}

struct Insert: ExpressionType {
	init(_ template: String, _ bindings: [Binding?]) { }
}

struct Update: ExpressionType {
	init(_ template: String, _ bindings: [Binding?]) { }
}

extension Connection {
	@discardableResult public func run(_ query: Insert) throws -> Int64 { return 0 }
	@discardableResult public func run(_ query: Update) throws -> Int { return 0 }
}

struct Setter { }

infix operator <-

func <-<V>(column: Expression<V>, value: Expression<V>) -> Setter { return Setter() }
func <-<V>(column: Expression<V>, value: V) -> Setter { return Setter() }

enum OnConflict: String {
	case replace = "REPLACE"
}

extension QueryType {
	func filter(_ predicate: Expression<Bool>) -> Self { return self }

	func insert(_ value: Setter, _ more: Setter...) -> Insert { return Insert("") }
	func insertMany(_ values: [[Setter]]) -> Insert { return Insert("") }
	func insertMany(or onConflict: OnConflict, _ values: [[Setter]]) -> Insert { return Insert("") }

	func update(_ values: Setter...) -> Update { return Update("") }
}

func ==<V>(lhs: Expression<V>, rhs: V) -> Expression<Bool> { return Expression<Bool>("") }

// --- tests ---

func test_sqlite_swift_api(db: Connection, id: Int, mobilePhoneNumber: String) throws {
	// --- sensitive data in SQL (in practice these cases may also be SQL injection) ---

	let insertQuery = "INSERT INTO CONTACTS(ID, NUMBER) VALUES(\(id), \(mobilePhoneNumber));"
	let updateQuery = "UPDATE CONTACTS SET NUMBER=\(mobilePhoneNumber) WHERE ID=\(id);"
	let deleteQuery = "DELETE FROM CONTACTS WHERE ID=\(id);"

	try db.execute(insertQuery) // BAD (sensitive data)
	try db.execute(updateQuery) // BAD (sensitive data)
	try db.execute(deleteQuery) // GOOD

	_ = try db.prepare(insertQuery).run() // BAD (sensitive data)
	_ = try db.prepare(updateQuery).run() // BAD (sensitive data)
	_ = try db.prepare(deleteQuery).run() // GOOD

	_ = try db.run(insertQuery) // BAD (sensitive data)
	_ = try db.run(updateQuery) // BAD (sensitive data)
	_ = try db.run(deleteQuery) // GOOD

	_ = try db.scalar(insertQuery) // BAD (sensitive data)
	_ = try db.scalar(updateQuery) // BAD (sensitive data)
	_ = try db.scalar(deleteQuery) // GOOD

	_ = try Statement(db, insertQuery).run() // BAD (sensitive data)
	_ = try Statement(db, updateQuery).run() // BAD (sensitive data)
	_ = try Statement(db, deleteQuery).run() // GOOD

	// --- sensitive data in bindings ---

	let varQuery1 = "UPDATE CONTACTS SET NUMBER=?;"

	_ = try db.prepare(varQuery1, mobilePhoneNumber).run() // BAD (sensitive data)
	_ = try db.run(varQuery1, mobilePhoneNumber) // BAD (sensitive data)
	_ = try db.scalar(varQuery1, mobilePhoneNumber) // BAD (sensitive data)

	let stmt1 = try db.prepare(varQuery1) // GOOD
	_ = try stmt1.bind(mobilePhoneNumber).run() // BAD (sensitive data)
	_ = try stmt1.run(mobilePhoneNumber) // BAD (sensitive data)
	_ = try stmt1.scalar(mobilePhoneNumber) // BAD (sensitive data)

	let varQuery2 = "UPDATE CONTACTS SET NUMBER=? WHERE ID=?;"

	_ = try db.prepare(varQuery2, [mobilePhoneNumber, id]).run() // BAD (sensitive data)
	_ = try db.run(varQuery2, [mobilePhoneNumber, id]) // BAD (sensitive data)
	_ = try db.scalar(varQuery2, [mobilePhoneNumber, id]) // BAD (sensitive data)

	let stmt2 = try db.prepare(varQuery2) // GOOD
	_ = try stmt2.bind([mobilePhoneNumber, id]).run() // BAD (sensitive data)
	_ = try stmt2.run([mobilePhoneNumber, id]) // BAD (sensitive data)
	_ = try stmt2.scalar([mobilePhoneNumber, id]) // BAD (sensitive data)

	let varQuery3 = "UPDATE CONTACTS SET NUMBER=$number WHERE ID=$id;"

	_ = try db.prepare(varQuery3, ["id": id, "number": mobilePhoneNumber]).run() // BAD (sensitive data)
	_ = try db.run(varQuery3, ["id": id, "number": mobilePhoneNumber]) // BAD (sensitive data)
	_ = try db.scalar(varQuery3, ["id": id, "number": mobilePhoneNumber]) // BAD (sensitive data)

	let stmt3 = try db.prepare(varQuery3) // GOOD
	_ = try stmt3.bind(["id": id, "number": mobilePhoneNumber]).run() // BAD (sensitive data)
	_ = try stmt3.run(["id": id, "number": mobilePhoneNumber]) // BAD (sensitive data)
	_ = try stmt3.scalar(["id": id, "number": mobilePhoneNumber]) // BAD (sensitive data)

	// --- higher level insert / update ---

	let table = Table("TABLE")
	let idExpr = Expression<Int>("ID")
	let numberExpr = Expression<String>("NUMBER")
	let filter = table.filter(idExpr == id) // GOOD

	try db.run(table.insert(idExpr <- id, numberExpr <- "123")) // GOOD
	try db.run(table.insert(idExpr <- id, numberExpr <- mobilePhoneNumber)) // BAD (sensitive data)

	try db.run(table.update(numberExpr <- "123")) // GOOD
	try db.run(table.update(numberExpr <- mobilePhoneNumber)) // BAD (sensitive data)
	try db.run(filter.update(numberExpr <- "123")) // GOOD
	try db.run(filter.update(numberExpr <- mobilePhoneNumber)) // BAD (sensitive data)
	try db.run(table.update(numberExpr <- numberExpr.replace("123", with: "456"))) // GOOD
	try db.run(table.update(numberExpr <- numberExpr.replace("123", with: mobilePhoneNumber))) // BAD (sensitive data)
	// (much more complex query construction is possible in SQLite.swift)

	let goodMany = [[numberExpr <- "456"]]
	let badMany = [[numberExpr <- mobilePhoneNumber]]
	try db.run(table.insertMany(goodMany)) // GOOD
	try db.run(table.insertMany(badMany)) // BAD (sensitive data)
	try db.run(table.insertMany(or: OnConflict.replace, goodMany)) // GOOD
	try db.run(table.insertMany(or: OnConflict.replace, badMany)) // BAD (sensitive data)
}
