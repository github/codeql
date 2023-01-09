// --- stubs ---

struct URL
{
	init?(string: String) {}
}

extension String {
	init(contentsOf: URL) throws {
		let data = ""

		// ...

		self.init(data)
	}
}

struct StatementArguments {}
class Statement {}
protocol RowAdapter {}
class RowDecoder {}
enum GeneratedColumnQualification { case virtual }
struct QueryInterfaceRequest<T> {}

class Database {
    func allStatements(sql: String, arguments: StatementArguments? = nil) -> SQLStatementCursor { return SQLStatementCursor(database: self, sql: "", arguments: nil) }
    func cachedStatement(sql: String) -> Statement { return Statement() }
    func internalCachedStatement(sql: String) -> Statement { return Statement() }
    func execute(sql: String, arguments: StatementArguments = StatementArguments()) {}
    func makeStatement(sql: String) -> Statement { return Statement() }
    func makeStatement(sql: String, prepFlags: CUnsignedInt) -> Statement { return Statement() }
}

struct SQLRequest {
    init(stringLiteral: String) {}
    init(unicodeScalarLiteral: String) {}
    init(extendedGraphemeClusterLiteral: String) {}
    init(stringInterpolation: String) {}
    init(sql: String, arguments: StatementArguments = StatementArguments(), adapter: (any RowAdapter)? = nil, cached: Bool = false) {}
}

struct SQL {
    init(stringLiteral: String) {}
    init(unicodeScalarLiteral: String) {}
    init(extendedGraphemeClusterLiteral: String) {}
    init(stringInterpolation: String) {}
    init(sql: String, arguments: StatementArguments = StatementArguments()) {}
    func append(sql: String, arguments: StatementArguments = StatementArguments()) {}
}

class TableDefinition {
    func column(sql: String) {}
    func check(sql: String) {}
    func constraint(sql: String) {}
}

class TableAlteration {
    func addColumn(sql: String) {}
}

class ColumnDefinition {
    func check(sql: String) -> Self { return self }
    func defaults(sql: String) -> Self { return self }
    func generatedAs(sql: String, _: GeneratedColumnQualification = .virtual) -> Self { return self }
}

class TableRecord {
    static func select(sql: String, arguments: StatementArguments = StatementArguments()) -> QueryInterfaceRequest<TableRecord> { QueryInterfaceRequest<TableRecord>() }
    static func select<RowDecoder>(sql: String, arguments: StatementArguments = StatementArguments(), as: RowDecoder.Type = RowDecoder.self) -> QueryInterfaceRequest<TableRecord>{ QueryInterfaceRequest<TableRecord>() }
    static func filter(sql: String, arguments: StatementArguments = StatementArguments()) -> QueryInterfaceRequest<TableRecord> { QueryInterfaceRequest<TableRecord>() }
    static func order(sql: String, arguments: StatementArguments = StatementArguments()) -> QueryInterfaceRequest<TableRecord> { QueryInterfaceRequest<TableRecord>() }
}

struct StatementCache {
    func statement(_: String) -> Statement { return Statement() }
}

class Row {
    func fetchCursor(_: Statement, sql: String, arguments: StatementArguments? = nil, adapter: (any RowAdapter)? = nil) {}
    func fetchAll(_: Statement, sql: String, arguments: StatementArguments? = nil, adapter: (any RowAdapter)? = nil) {}
    func fetchSet(_: Statement, sql: String, arguments: StatementArguments? = nil, adapter: (any RowAdapter)? = nil) {}
    func fetchOne(_: Statement, sql: String, arguments: StatementArguments? = nil, adapter: (any RowAdapter)? = nil) {}
}

class DatabaseValueConvertible {
    func fetchCursor(_: Statement, sql: String, arguments: StatementArguments? = nil, adapter: (any RowAdapter)? = nil) {}
    func fetchAll(_: Statement, sql: String, arguments: StatementArguments? = nil, adapter: (any RowAdapter)? = nil) {}
    func fetchSet(_: Statement, sql: String, arguments: StatementArguments? = nil, adapter: (any RowAdapter)? = nil) {}
    func fetchOne(_: Statement, sql: String, arguments: StatementArguments? = nil, adapter: (any RowAdapter)? = nil) {}
}

class SQLStatementCursor {
    init(database: Database, sql: String, arguments: StatementArguments?, prepFlags: CUnsignedInt = 0) {}
}

class CommonTableExpression {
    init(recursive: Bool = false, named: String, columns: [String]? = nil, sql: String, arguments: StatementArguments = StatementArguments()) {}
}

// --- tests ---

func test(database: Database) throws {
    let localString = "user"
	let remoteString = try String(contentsOf: URL(string: "http://example.com/")!)

    let _ = database.allStatements(sql: remoteString) // BAD
    let _ = database.allStatements(sql: localString) // GOOD
    let _ = database.allStatements(sql: remoteString, arguments: nil) // BAD
    let _ = database.allStatements(sql: localString, arguments: nil) // GOOD

    let _ = database.cachedStatement(sql: remoteString) // BAD
    let _ = database.cachedStatement(sql: localString) // GOOD

    let _ = database.internalCachedStatement(sql: remoteString) // BAD
    let _ = database.internalCachedStatement(sql: localString) // GOOD

    database.execute(sql: remoteString) // BAD
    database.execute(sql: localString) // GOOD
    database.execute(sql: remoteString, arguments: StatementArguments()) // BAD
    database.execute(sql: localString, arguments: StatementArguments()) // GOOD
    
    let _ = database.makeStatement(sql: remoteString) // BAD
    let _ = database.makeStatement(sql: localString) // GOOD
    let _ = database.makeStatement(sql: remoteString, prepFlags: 0) // BAD
    let _ = database.makeStatement(sql: localString, prepFlags: 0) // GOOD
}

func testSqlRequest() throws {
    let localString = "user"
	let remoteString  = try String(contentsOf: URL(string: "http://example.com/")!)

    let _ = SQLRequest(stringLiteral: remoteString) // BAD
    let _ = SQLRequest(stringLiteral: localString) // GOOD

    let _ = SQLRequest(unicodeScalarLiteral: remoteString) // BAD
    let _ = SQLRequest(unicodeScalarLiteral: localString) // GOOD

    let _ = SQLRequest(extendedGraphemeClusterLiteral: remoteString) // BAD
    let _ = SQLRequest(extendedGraphemeClusterLiteral: localString) // GOOD

    let _ = SQLRequest(stringInterpolation: remoteString) // BAD
    let _ = SQLRequest(stringInterpolation: localString) // GOOD

    let _ = SQLRequest(sql: remoteString) // BAD
    let _ = SQLRequest(sql: remoteString, arguments: StatementArguments()) // BAD
    let _ = SQLRequest(sql: remoteString, arguments: StatementArguments(), adapter: nil) // BAD
    let _ = SQLRequest(sql: remoteString, arguments: StatementArguments(), cached: false) // BAD
    let _ = SQLRequest(sql: remoteString, arguments: StatementArguments(), adapter: nil, cached: false) // BAD
    let _ = SQLRequest(sql: remoteString, adapter: nil) // BAD
    let _ = SQLRequest(sql: remoteString, adapter: nil, cached: false) // BAD
    let _ = SQLRequest(sql: remoteString, cached: false) // BAD
    let _ = SQLRequest(sql: localString) // GOOD
    let _ = SQLRequest(sql: localString, arguments: StatementArguments()) // GOOD
    let _ = SQLRequest(sql: localString, arguments: StatementArguments(), adapter: nil) // GOOD
    let _ = SQLRequest(sql: localString, arguments: StatementArguments(), cached: false) // GOOD
    let _ = SQLRequest(sql: localString, arguments: StatementArguments(), adapter: nil, cached: false) // GOOD
    let _ = SQLRequest(sql: localString, adapter: nil) // GOOD
    let _ = SQLRequest(sql: localString, adapter: nil, cached: false) // GOOD
    let _ = SQLRequest(sql: localString, cached: false) // GOOD
}

func testSql() throws {
    let localString = "user"
	let remoteString  = try String(contentsOf: URL(string: "http://example.com/")!)

    let _ = SQL(stringLiteral: remoteString) // BAD
    let _ = SQL(unicodeScalarLiteral: remoteString) // BAD
    let _ = SQL(extendedGraphemeClusterLiteral: remoteString) // BAD
    let _ = SQL(stringInterpolation: remoteString) // BAD
    let _ = SQL(sql: remoteString) // BAD
    let sql1 = SQL(stringLiteral: "")
    sql1.append(sql: remoteString) // BAD

    let _ = SQL(stringLiteral: localString) // GOOD
    let _ = SQL(unicodeScalarLiteral: localString) // GOOD
    let _ = SQL(extendedGraphemeClusterLiteral: localString) // GOOD
    let _ = SQL(stringInterpolation: localString) // GOOD
    let _ = SQL(sql: localString) // GOOD
    let sql2 = SQL(stringLiteral: "")
    sql2.append(sql: localString) // GOOD
}

func test(tableDefinition: TableDefinition) throws {
    let localString = "user"
	let remoteString  = try String(contentsOf: URL(string: "http://example.com/")!)

    tableDefinition.column(sql: remoteString) // BAD
    tableDefinition.column(sql: localString) // GOOD
    
    tableDefinition.check(sql: remoteString) // BAD
    tableDefinition.check(sql: localString) // GOOD

    tableDefinition.constraint(sql: remoteString) // BAD
    tableDefinition.constraint(sql: localString) // GOOD
}

func test(tableAlteration: TableAlteration) throws {
    let localString = "user"
	let remoteString  = try String(contentsOf: URL(string: "http://example.com/")!)

    tableAlteration.addColumn(sql: remoteString) // BAD
    tableAlteration.addColumn(sql: localString) // GOOD
}

func test(columnDefinition: ColumnDefinition) throws {
    let localString = "user"
	let remoteString  = try String(contentsOf: URL(string: "http://example.com/")!)

    let _ = columnDefinition.check(sql: remoteString) // BAD
    let _ = columnDefinition.defaults(sql: remoteString) // BAD
    let _ = columnDefinition.generatedAs(sql: remoteString) // BAD
    let _ = columnDefinition.generatedAs(sql: remoteString, .virtual) // BAD
    
    let _ = columnDefinition.check(sql: localString) // GOOD
    let _ = columnDefinition.defaults(sql: localString) // GOOD
    let _ = columnDefinition.generatedAs(sql: localString) // GOOD
    let _ = columnDefinition.generatedAs(sql: localString, .virtual) // GOOD
}

func testTableRecord() throws {
    let localString = "user"
	let remoteString  = try String(contentsOf: URL(string: "http://example.com/")!)
    
    let _ = TableRecord.select(sql: remoteString) // BAD
    let _ = TableRecord.select(sql: remoteString, arguments: StatementArguments()) // BAD
    let _ = TableRecord.select(sql: localString) // GOOD
    let _ = TableRecord.select(sql: localString, arguments: StatementArguments()) // GOOD
    
    let _ = TableRecord.filter(sql: remoteString) // BAD
    let _ = TableRecord.filter(sql: remoteString, arguments: StatementArguments()) // BAD
    let _ = TableRecord.filter(sql: localString) // GOOD
    let _ = TableRecord.filter(sql: localString, arguments: StatementArguments()) // GOOD
    
    let _ = TableRecord.order(sql: remoteString) // BAD
    let _ = TableRecord.order(sql: remoteString, arguments: StatementArguments()) // BAD
    let _ = TableRecord.order(sql: localString) // GOOD
    let _ = TableRecord.order(sql: localString, arguments: StatementArguments()) // GOOD
}

func test(statementCache: StatementCache) throws {
    let localString = "user"
	let remoteString  = try String(contentsOf: URL(string: "http://example.com/")!)

    let _ = statementCache.statement(remoteString) // BAD
    let _ = statementCache.statement(localString) // GOOD
}

func test(row: Row, stmt: Statement) throws {
    let localString = "user"
	let remoteString  = try String(contentsOf: URL(string: "http://example.com/")!)

    row.fetchCursor(stmt, sql: remoteString) // BAD
    row.fetchCursor(stmt, sql: remoteString, arguments: StatementArguments()) // BAD
    row.fetchCursor(stmt, sql: remoteString, adapter: nil) // BAD
    row.fetchCursor(stmt, sql: remoteString, arguments: StatementArguments(), adapter: nil) // BAD
    row.fetchCursor(stmt, sql: localString) // GOOD
    row.fetchCursor(stmt, sql: localString, arguments: StatementArguments()) // GOOD
    row.fetchCursor(stmt, sql: localString, adapter: nil) // GOOD
    row.fetchCursor(stmt, sql: localString, arguments: StatementArguments(), adapter: nil) // GOOD

    row.fetchAll(stmt, sql: remoteString) // BAD
    row.fetchAll(stmt, sql: remoteString, arguments: StatementArguments()) // BAD
    row.fetchAll(stmt, sql: remoteString, adapter: nil) // BAD
    row.fetchAll(stmt, sql: remoteString, arguments: StatementArguments(), adapter: nil) // BAD
    row.fetchAll(stmt, sql: localString) // GOOD
    row.fetchAll(stmt, sql: localString, arguments: StatementArguments()) // GOOD
    row.fetchAll(stmt, sql: localString, adapter: nil) // GOOD
    row.fetchAll(stmt, sql: localString, arguments: StatementArguments(), adapter: nil) // GOOD

    row.fetchOne(stmt, sql: remoteString) // BAD
    row.fetchOne(stmt, sql: remoteString, arguments: StatementArguments()) // BAD
    row.fetchOne(stmt, sql: remoteString, adapter: nil) // BAD
    row.fetchOne(stmt, sql: remoteString, arguments: StatementArguments(), adapter: nil) // BAD
    row.fetchOne(stmt, sql: localString) // GOOD
    row.fetchOne(stmt, sql: localString, arguments: StatementArguments()) // GOOD
    row.fetchOne(stmt, sql: localString, adapter: nil) // GOOD
    row.fetchOne(stmt, sql: localString, arguments: StatementArguments(), adapter: nil) // GOOD

    row.fetchSet(stmt, sql: remoteString) // BAD
    row.fetchSet(stmt, sql: remoteString, arguments: StatementArguments()) // BAD
    row.fetchSet(stmt, sql: remoteString, adapter: nil) // BAD
    row.fetchSet(stmt, sql: remoteString, arguments: StatementArguments(), adapter: nil) // BAD
    row.fetchSet(stmt, sql: localString) // GOOD
    row.fetchSet(stmt, sql: localString, arguments: StatementArguments()) // GOOD
    row.fetchSet(stmt, sql: localString, adapter: nil) // GOOD
    row.fetchSet(stmt, sql: localString, arguments: StatementArguments(), adapter: nil) // GOOD
}

func test(databaseValueConvertible: DatabaseValueConvertible, stmt: Statement) throws {
    let localString = "user"
	let remoteString  = try String(contentsOf: URL(string: "http://example.com/")!)

    databaseValueConvertible.fetchCursor(stmt, sql: remoteString) // BAD
    databaseValueConvertible.fetchCursor(stmt, sql: remoteString, arguments: StatementArguments()) // BAD
    databaseValueConvertible.fetchCursor(stmt, sql: remoteString, adapter: nil) // BAD
    databaseValueConvertible.fetchCursor(stmt, sql: remoteString, arguments: StatementArguments(), adapter: nil) // BAD
    databaseValueConvertible.fetchCursor(stmt, sql: localString) // GOOD
    databaseValueConvertible.fetchCursor(stmt, sql: localString, arguments: StatementArguments()) // GOOD
    databaseValueConvertible.fetchCursor(stmt, sql: localString, adapter: nil) // GOOD
    databaseValueConvertible.fetchCursor(stmt, sql: localString, arguments: StatementArguments(), adapter: nil) // GOOD

    databaseValueConvertible.fetchAll(stmt, sql: remoteString) // BAD
    databaseValueConvertible.fetchAll(stmt, sql: remoteString, arguments: StatementArguments()) // BAD
    databaseValueConvertible.fetchAll(stmt, sql: remoteString, adapter: nil) // BAD
    databaseValueConvertible.fetchAll(stmt, sql: remoteString, arguments: StatementArguments(), adapter: nil) // BAD
    databaseValueConvertible.fetchAll(stmt, sql: localString) // GOOD
    databaseValueConvertible.fetchAll(stmt, sql: localString, arguments: StatementArguments()) // GOOD
    databaseValueConvertible.fetchAll(stmt, sql: localString, adapter: nil) // GOOD
    databaseValueConvertible.fetchAll(stmt, sql: localString, arguments: StatementArguments(), adapter: nil) // GOOD

    databaseValueConvertible.fetchOne(stmt, sql: remoteString) // BAD
    databaseValueConvertible.fetchOne(stmt, sql: remoteString, arguments: StatementArguments()) // BAD
    databaseValueConvertible.fetchOne(stmt, sql: remoteString, adapter: nil) // BAD
    databaseValueConvertible.fetchOne(stmt, sql: remoteString, arguments: StatementArguments(), adapter: nil) // BAD
    databaseValueConvertible.fetchOne(stmt, sql: localString) // GOOD
    databaseValueConvertible.fetchOne(stmt, sql: localString, arguments: StatementArguments()) // GOOD
    databaseValueConvertible.fetchOne(stmt, sql: localString, adapter: nil) // GOOD
    databaseValueConvertible.fetchOne(stmt, sql: localString, arguments: StatementArguments(), adapter: nil) // GOOD

    databaseValueConvertible.fetchSet(stmt, sql: remoteString) // BAD
    databaseValueConvertible.fetchSet(stmt, sql: remoteString, arguments: StatementArguments()) // BAD
    databaseValueConvertible.fetchSet(stmt, sql: remoteString, adapter: nil) // BAD
    databaseValueConvertible.fetchSet(stmt, sql: remoteString, arguments: StatementArguments(), adapter: nil) // BAD
    databaseValueConvertible.fetchSet(stmt, sql: localString) // GOOD
    databaseValueConvertible.fetchSet(stmt, sql: localString, arguments: StatementArguments()) // GOOD
    databaseValueConvertible.fetchSet(stmt, sql: localString, adapter: nil) // GOOD
    databaseValueConvertible.fetchSet(stmt, sql: localString, arguments: StatementArguments(), adapter: nil) // GOOD
}

func testSqlStatementCursor(database: Database) throws {
    let localString = "user"
	let remoteString  = try String(contentsOf: URL(string: "http://example.com/")!)

    let _ = SQLStatementCursor(database: database, sql: remoteString, arguments: StatementArguments()) // BAD
    let _ = SQLStatementCursor(database: database, sql: remoteString, arguments: StatementArguments(), prepFlags: 0) // BAD
    let _ = SQLStatementCursor(database: database, sql: localString, arguments: StatementArguments()) // GOOD
    let _ = SQLStatementCursor(database: database, sql: localString, arguments: StatementArguments(), prepFlags: 0) // GOOD
}

func testCommonTableExpression() throws {
    let localString = "user"
	let remoteString  = try String(contentsOf: URL(string: "http://example.com/")!)

    let _ = CommonTableExpression(named: "", sql: remoteString) // BAD
    let _ = CommonTableExpression(named: "", sql: remoteString, arguments: StatementArguments()) // BAD
    let _ = CommonTableExpression(named: "", columns: [""], sql: remoteString) // BAD
    let _ = CommonTableExpression(named: "", columns: [""], sql: remoteString, arguments: StatementArguments()) // BAD
    let _ = CommonTableExpression(recursive: false, named: "", sql: remoteString) // BAD
    let _ = CommonTableExpression(recursive: false, named: "", columns: [""], sql: remoteString) // BAD
    let _ = CommonTableExpression(recursive: false, named: "", sql: remoteString, arguments: StatementArguments()) // BAD
    let _ = CommonTableExpression(recursive: false, named: "", columns: [""], sql: remoteString, arguments: StatementArguments()) // BAD
    let _ = CommonTableExpression(named: "", sql: localString) // GOOD
    let _ = CommonTableExpression(named: "", sql: localString, arguments: StatementArguments()) // GOOD
    let _ = CommonTableExpression(named: "", columns: [""], sql: localString) // GOOD
    let _ = CommonTableExpression(named: "", columns: [""], sql: localString, arguments: StatementArguments()) // GOOD
    let _ = CommonTableExpression(recursive: false, named: "", sql: localString) // GOOD
    let _ = CommonTableExpression(recursive: false, named: "", columns: [""], sql: localString) // GOOD
    let _ = CommonTableExpression(recursive: false, named: "", sql: localString, arguments: StatementArguments()) // GOOD
    let _ = CommonTableExpression(recursive: false, named: "", columns: [""], sql: localString, arguments: StatementArguments()) // GOOD
}
