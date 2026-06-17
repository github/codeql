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
	let remoteString = try String(contentsOf: URL(string: "http://example.com/")!) // $ Source

    let _ = database.allStatements(sql: remoteString) // $ Alert
    let _ = database.allStatements(sql: localString) // GOOD
    let _ = database.allStatements(sql: remoteString, arguments: nil) // $ Alert
    let _ = database.allStatements(sql: localString, arguments: nil) // GOOD

    let _ = database.cachedStatement(sql: remoteString) // $ Alert
    let _ = database.cachedStatement(sql: localString) // GOOD

    let _ = database.internalCachedStatement(sql: remoteString) // $ Alert
    let _ = database.internalCachedStatement(sql: localString) // GOOD

    database.execute(sql: remoteString) // $ Alert
    database.execute(sql: localString) // GOOD
    database.execute(sql: remoteString, arguments: StatementArguments()) // $ Alert
    database.execute(sql: localString, arguments: StatementArguments()) // GOOD
    
    let _ = database.makeStatement(sql: remoteString) // $ Alert
    let _ = database.makeStatement(sql: localString) // GOOD
    let _ = database.makeStatement(sql: remoteString, prepFlags: 0) // $ Alert
    let _ = database.makeStatement(sql: localString, prepFlags: 0) // GOOD
}

func testSqlRequest() throws {
    let localString = "user"
	let remoteString  = try String(contentsOf: URL(string: "http://example.com/")!) // $ Source

    let _ = SQLRequest(stringLiteral: remoteString) // $ Alert
    let _ = SQLRequest(stringLiteral: localString) // GOOD

    let _ = SQLRequest(unicodeScalarLiteral: remoteString) // $ Alert
    let _ = SQLRequest(unicodeScalarLiteral: localString) // GOOD

    let _ = SQLRequest(extendedGraphemeClusterLiteral: remoteString) // $ Alert
    let _ = SQLRequest(extendedGraphemeClusterLiteral: localString) // GOOD

    let _ = SQLRequest(stringInterpolation: remoteString) // $ Alert
    let _ = SQLRequest(stringInterpolation: localString) // GOOD

    let _ = SQLRequest(sql: remoteString) // $ Alert
    let _ = SQLRequest(sql: remoteString, arguments: StatementArguments()) // $ Alert
    let _ = SQLRequest(sql: remoteString, arguments: StatementArguments(), adapter: nil) // $ Alert
    let _ = SQLRequest(sql: remoteString, arguments: StatementArguments(), cached: false) // $ Alert
    let _ = SQLRequest(sql: remoteString, arguments: StatementArguments(), adapter: nil, cached: false) // $ Alert
    let _ = SQLRequest(sql: remoteString, adapter: nil) // $ Alert
    let _ = SQLRequest(sql: remoteString, adapter: nil, cached: false) // $ Alert
    let _ = SQLRequest(sql: remoteString, cached: false) // $ Alert
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
	let remoteString  = try String(contentsOf: URL(string: "http://example.com/")!) // $ Source

    let _ = SQL(stringLiteral: remoteString) // $ Alert
    let _ = SQL(unicodeScalarLiteral: remoteString) // $ Alert
    let _ = SQL(extendedGraphemeClusterLiteral: remoteString) // $ Alert
    let _ = SQL(stringInterpolation: remoteString) // $ Alert
    let _ = SQL(sql: remoteString) // $ Alert
    let sql1 = SQL(stringLiteral: "")
    sql1.append(sql: remoteString) // $ Alert

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
	let remoteString  = try String(contentsOf: URL(string: "http://example.com/")!) // $ Source

    tableDefinition.column(sql: remoteString) // $ Alert
    tableDefinition.column(sql: localString) // GOOD
    
    tableDefinition.check(sql: remoteString) // $ Alert
    tableDefinition.check(sql: localString) // GOOD

    tableDefinition.constraint(sql: remoteString) // $ Alert
    tableDefinition.constraint(sql: localString) // GOOD
}

func test(tableAlteration: TableAlteration) throws {
    let localString = "user"
	let remoteString  = try String(contentsOf: URL(string: "http://example.com/")!) // $ Source

    tableAlteration.addColumn(sql: remoteString) // $ Alert
    tableAlteration.addColumn(sql: localString) // GOOD
}

func test(columnDefinition: ColumnDefinition) throws {
    let localString = "user"
	let remoteString  = try String(contentsOf: URL(string: "http://example.com/")!) // $ Source

    let _ = columnDefinition.check(sql: remoteString) // $ Alert
    let _ = columnDefinition.defaults(sql: remoteString) // $ Alert
    let _ = columnDefinition.generatedAs(sql: remoteString) // $ Alert
    let _ = columnDefinition.generatedAs(sql: remoteString, .virtual) // $ Alert
    
    let _ = columnDefinition.check(sql: localString) // GOOD
    let _ = columnDefinition.defaults(sql: localString) // GOOD
    let _ = columnDefinition.generatedAs(sql: localString) // GOOD
    let _ = columnDefinition.generatedAs(sql: localString, .virtual) // GOOD
}

func testTableRecord() throws {
    let localString = "user"
	let remoteString  = try String(contentsOf: URL(string: "http://example.com/")!) // $ Source
    
    let _ = TableRecord.select(sql: remoteString) // $ Alert
    let _ = TableRecord.select(sql: remoteString, arguments: StatementArguments()) // $ Alert
    let _ = TableRecord.select(sql: localString) // GOOD
    let _ = TableRecord.select(sql: localString, arguments: StatementArguments()) // GOOD
    
    let _ = TableRecord.filter(sql: remoteString) // $ Alert
    let _ = TableRecord.filter(sql: remoteString, arguments: StatementArguments()) // $ Alert
    let _ = TableRecord.filter(sql: localString) // GOOD
    let _ = TableRecord.filter(sql: localString, arguments: StatementArguments()) // GOOD
    
    let _ = TableRecord.order(sql: remoteString) // $ Alert
    let _ = TableRecord.order(sql: remoteString, arguments: StatementArguments()) // $ Alert
    let _ = TableRecord.order(sql: localString) // GOOD
    let _ = TableRecord.order(sql: localString, arguments: StatementArguments()) // GOOD
}

func test(statementCache: StatementCache) throws {
    let localString = "user"
	let remoteString  = try String(contentsOf: URL(string: "http://example.com/")!) // $ Source

    let _ = statementCache.statement(remoteString) // $ Alert
    let _ = statementCache.statement(localString) // GOOD
}

func test(row: Row, stmt: Statement) throws {
    let localString = "user"
	let remoteString  = try String(contentsOf: URL(string: "http://example.com/")!) // $ Source

    row.fetchCursor(stmt, sql: remoteString) // $ Alert
    row.fetchCursor(stmt, sql: remoteString, arguments: StatementArguments()) // $ Alert
    row.fetchCursor(stmt, sql: remoteString, adapter: nil) // $ Alert
    row.fetchCursor(stmt, sql: remoteString, arguments: StatementArguments(), adapter: nil) // $ Alert
    row.fetchCursor(stmt, sql: localString) // GOOD
    row.fetchCursor(stmt, sql: localString, arguments: StatementArguments()) // GOOD
    row.fetchCursor(stmt, sql: localString, adapter: nil) // GOOD
    row.fetchCursor(stmt, sql: localString, arguments: StatementArguments(), adapter: nil) // GOOD

    row.fetchAll(stmt, sql: remoteString) // $ Alert
    row.fetchAll(stmt, sql: remoteString, arguments: StatementArguments()) // $ Alert
    row.fetchAll(stmt, sql: remoteString, adapter: nil) // $ Alert
    row.fetchAll(stmt, sql: remoteString, arguments: StatementArguments(), adapter: nil) // $ Alert
    row.fetchAll(stmt, sql: localString) // GOOD
    row.fetchAll(stmt, sql: localString, arguments: StatementArguments()) // GOOD
    row.fetchAll(stmt, sql: localString, adapter: nil) // GOOD
    row.fetchAll(stmt, sql: localString, arguments: StatementArguments(), adapter: nil) // GOOD

    row.fetchOne(stmt, sql: remoteString) // $ Alert
    row.fetchOne(stmt, sql: remoteString, arguments: StatementArguments()) // $ Alert
    row.fetchOne(stmt, sql: remoteString, adapter: nil) // $ Alert
    row.fetchOne(stmt, sql: remoteString, arguments: StatementArguments(), adapter: nil) // $ Alert
    row.fetchOne(stmt, sql: localString) // GOOD
    row.fetchOne(stmt, sql: localString, arguments: StatementArguments()) // GOOD
    row.fetchOne(stmt, sql: localString, adapter: nil) // GOOD
    row.fetchOne(stmt, sql: localString, arguments: StatementArguments(), adapter: nil) // GOOD

    row.fetchSet(stmt, sql: remoteString) // $ Alert
    row.fetchSet(stmt, sql: remoteString, arguments: StatementArguments()) // $ Alert
    row.fetchSet(stmt, sql: remoteString, adapter: nil) // $ Alert
    row.fetchSet(stmt, sql: remoteString, arguments: StatementArguments(), adapter: nil) // $ Alert
    row.fetchSet(stmt, sql: localString) // GOOD
    row.fetchSet(stmt, sql: localString, arguments: StatementArguments()) // GOOD
    row.fetchSet(stmt, sql: localString, adapter: nil) // GOOD
    row.fetchSet(stmt, sql: localString, arguments: StatementArguments(), adapter: nil) // GOOD
}

func test(databaseValueConvertible: DatabaseValueConvertible, stmt: Statement) throws {
    let localString = "user"
	let remoteString  = try String(contentsOf: URL(string: "http://example.com/")!) // $ Source

    databaseValueConvertible.fetchCursor(stmt, sql: remoteString) // $ Alert
    databaseValueConvertible.fetchCursor(stmt, sql: remoteString, arguments: StatementArguments()) // $ Alert
    databaseValueConvertible.fetchCursor(stmt, sql: remoteString, adapter: nil) // $ Alert
    databaseValueConvertible.fetchCursor(stmt, sql: remoteString, arguments: StatementArguments(), adapter: nil) // $ Alert
    databaseValueConvertible.fetchCursor(stmt, sql: localString) // GOOD
    databaseValueConvertible.fetchCursor(stmt, sql: localString, arguments: StatementArguments()) // GOOD
    databaseValueConvertible.fetchCursor(stmt, sql: localString, adapter: nil) // GOOD
    databaseValueConvertible.fetchCursor(stmt, sql: localString, arguments: StatementArguments(), adapter: nil) // GOOD

    databaseValueConvertible.fetchAll(stmt, sql: remoteString) // $ Alert
    databaseValueConvertible.fetchAll(stmt, sql: remoteString, arguments: StatementArguments()) // $ Alert
    databaseValueConvertible.fetchAll(stmt, sql: remoteString, adapter: nil) // $ Alert
    databaseValueConvertible.fetchAll(stmt, sql: remoteString, arguments: StatementArguments(), adapter: nil) // $ Alert
    databaseValueConvertible.fetchAll(stmt, sql: localString) // GOOD
    databaseValueConvertible.fetchAll(stmt, sql: localString, arguments: StatementArguments()) // GOOD
    databaseValueConvertible.fetchAll(stmt, sql: localString, adapter: nil) // GOOD
    databaseValueConvertible.fetchAll(stmt, sql: localString, arguments: StatementArguments(), adapter: nil) // GOOD

    databaseValueConvertible.fetchOne(stmt, sql: remoteString) // $ Alert
    databaseValueConvertible.fetchOne(stmt, sql: remoteString, arguments: StatementArguments()) // $ Alert
    databaseValueConvertible.fetchOne(stmt, sql: remoteString, adapter: nil) // $ Alert
    databaseValueConvertible.fetchOne(stmt, sql: remoteString, arguments: StatementArguments(), adapter: nil) // $ Alert
    databaseValueConvertible.fetchOne(stmt, sql: localString) // GOOD
    databaseValueConvertible.fetchOne(stmt, sql: localString, arguments: StatementArguments()) // GOOD
    databaseValueConvertible.fetchOne(stmt, sql: localString, adapter: nil) // GOOD
    databaseValueConvertible.fetchOne(stmt, sql: localString, arguments: StatementArguments(), adapter: nil) // GOOD

    databaseValueConvertible.fetchSet(stmt, sql: remoteString) // $ Alert
    databaseValueConvertible.fetchSet(stmt, sql: remoteString, arguments: StatementArguments()) // $ Alert
    databaseValueConvertible.fetchSet(stmt, sql: remoteString, adapter: nil) // $ Alert
    databaseValueConvertible.fetchSet(stmt, sql: remoteString, arguments: StatementArguments(), adapter: nil) // $ Alert
    databaseValueConvertible.fetchSet(stmt, sql: localString) // GOOD
    databaseValueConvertible.fetchSet(stmt, sql: localString, arguments: StatementArguments()) // GOOD
    databaseValueConvertible.fetchSet(stmt, sql: localString, adapter: nil) // GOOD
    databaseValueConvertible.fetchSet(stmt, sql: localString, arguments: StatementArguments(), adapter: nil) // GOOD
}

func testSqlStatementCursor(database: Database) throws {
    let localString = "user"
	let remoteString  = try String(contentsOf: URL(string: "http://example.com/")!) // $ Source

    let _ = SQLStatementCursor(database: database, sql: remoteString, arguments: StatementArguments()) // $ Alert
    let _ = SQLStatementCursor(database: database, sql: remoteString, arguments: StatementArguments(), prepFlags: 0) // $ Alert
    let _ = SQLStatementCursor(database: database, sql: localString, arguments: StatementArguments()) // GOOD
    let _ = SQLStatementCursor(database: database, sql: localString, arguments: StatementArguments(), prepFlags: 0) // GOOD
}

func testCommonTableExpression() throws {
    let localString = "user"
	let remoteString  = try String(contentsOf: URL(string: "http://example.com/")!) // $ Source

    let _ = CommonTableExpression(named: "", sql: remoteString) // $ Alert
    let _ = CommonTableExpression(named: "", sql: remoteString, arguments: StatementArguments()) // $ Alert
    let _ = CommonTableExpression(named: "", columns: [""], sql: remoteString) // $ Alert
    let _ = CommonTableExpression(named: "", columns: [""], sql: remoteString, arguments: StatementArguments()) // $ Alert
    let _ = CommonTableExpression(recursive: false, named: "", sql: remoteString) // $ Alert
    let _ = CommonTableExpression(recursive: false, named: "", columns: [""], sql: remoteString) // $ Alert
    let _ = CommonTableExpression(recursive: false, named: "", sql: remoteString, arguments: StatementArguments()) // $ Alert
    let _ = CommonTableExpression(recursive: false, named: "", columns: [""], sql: remoteString, arguments: StatementArguments()) // $ Alert
    let _ = CommonTableExpression(named: "", sql: localString) // GOOD
    let _ = CommonTableExpression(named: "", sql: localString, arguments: StatementArguments()) // GOOD
    let _ = CommonTableExpression(named: "", columns: [""], sql: localString) // GOOD
    let _ = CommonTableExpression(named: "", columns: [""], sql: localString, arguments: StatementArguments()) // GOOD
    let _ = CommonTableExpression(recursive: false, named: "", sql: localString) // GOOD
    let _ = CommonTableExpression(recursive: false, named: "", columns: [""], sql: localString) // GOOD
    let _ = CommonTableExpression(recursive: false, named: "", sql: localString, arguments: StatementArguments()) // GOOD
    let _ = CommonTableExpression(recursive: false, named: "", columns: [""], sql: localString, arguments: StatementArguments()) // GOOD
}
