// --- stubs ---

struct StatementArguments : ExpressibleByArrayLiteral {
    init(arrayLiteral: (String)?...) {}
}

protocol RowAdapter {}

struct QueryInterfaceRequest<T> {}

class Database {
    func allStatements(sql: String, arguments: StatementArguments? = nil) -> SQLStatementCursor { return SQLStatementCursor(database: self, sql: "", arguments: nil) }
    func execute(sql: String, arguments: StatementArguments = StatementArguments()) {}
}

class SQLRequest {
    init(sql: String, arguments: StatementArguments = StatementArguments(), adapter: (any RowAdapter)? = nil, cached: Bool = false) {}
}

class SQL {
    init(sql: String, arguments: StatementArguments = StatementArguments()) {}
    func append(sql: String, arguments: StatementArguments = StatementArguments()) {}
}

class SQLStatementCursor {
    init(database: Database, sql: String, arguments: StatementArguments?, prepFlags: CUnsignedInt = 0) {}
}

class TableRecord {
    static func select(sql: String, arguments: StatementArguments = StatementArguments()) -> QueryInterfaceRequest<TableRecord> { QueryInterfaceRequest<TableRecord>() }
    static func select<RowDecoder>(sql: String, arguments: StatementArguments = StatementArguments(), as: RowDecoder.Type = RowDecoder.self) -> QueryInterfaceRequest<TableRecord>{ QueryInterfaceRequest<TableRecord>() }
    static func filter(sql: String, arguments: StatementArguments = StatementArguments()) -> QueryInterfaceRequest<TableRecord> { QueryInterfaceRequest<TableRecord>() }
    static func order(sql: String, arguments: StatementArguments = StatementArguments()) -> QueryInterfaceRequest<TableRecord> { QueryInterfaceRequest<TableRecord>() }
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

class FetchableRecord {
    func fetchCursor(_: Statement, sql: String, arguments: StatementArguments? = nil, adapter: (any RowAdapter)? = nil) {}
    func fetchCursor(_: Statement, arguments: StatementArguments? = nil, adapter: (any RowAdapter)? = nil) {}
    func fetchAll(_: Statement, sql: String, arguments: StatementArguments? = nil, adapter: (any RowAdapter)? = nil) {}
    func fetchAll(_: Statement, arguments: StatementArguments? = nil, adapter: (any RowAdapter)? = nil) {}
    func fetchSet(_: Statement, sql: String, arguments: StatementArguments? = nil, adapter: (any RowAdapter)? = nil) {}
    func fetchSet(_: Statement, arguments: StatementArguments? = nil, adapter: (any RowAdapter)? = nil) {}
    func fetchOne(_: Statement, sql: String, arguments: StatementArguments? = nil, adapter: (any RowAdapter)? = nil) {}
    func fetchOne(_: Statement, arguments: StatementArguments? = nil, adapter: (any RowAdapter)? = nil) {}
}

class Statement {
    func execute(arguments: StatementArguments? = nil) {}
    func setArguments(_: StatementArguments) {}
}

class CommonTableExpression {
    init(recursive: Bool = false, named: String, columns: [String]? = nil, sql: String, arguments: StatementArguments = StatementArguments()) {}
}

// --- tests ---

func test(database: Database, password: String, harmless: String) {
    let _ = database.allStatements(sql: "", arguments: [password]) // BAD
    let _ = database.allStatements(sql: "", arguments: [harmless]) // GOOD

    database.execute(sql: "", arguments: [password]) // BAD
    database.execute(sql: "", arguments: [harmless]) // GOOD
}

func testSqlRequest(password: String, harmless: String) {
    let _ = SQLRequest(sql: "", arguments: [password]) // BAD
    let _ = SQLRequest(sql: "", arguments: [harmless]) // GOOD
    let _ = SQLRequest(sql: "", arguments: [password], adapter: nil) // BAD
    let _ = SQLRequest(sql: "", arguments: [harmless], adapter: nil) // GOOD
    let _ = SQLRequest(sql: "", arguments: [password], cached: false) // BAD
    let _ = SQLRequest(sql: "", arguments: [harmless], cached: false) // GOOD
    let _ = SQLRequest(sql: "", arguments: [password], adapter: nil, cached: false) // BAD
    let _ = SQLRequest(sql: "", arguments: [harmless], adapter: nil, cached: false) // GOOD
}

func test(sql: SQL, password: String, harmless: String) {
    let _ = SQL(sql: "", arguments: [password]) // BAD
    let _ = SQL(sql: "", arguments: [harmless]) // GOOD
    
    sql.append(sql: "", arguments: [password]) // BAD
    sql.append(sql: "", arguments: [harmless]) // GOOD
}

func testSqlStatementCursor(database: Database, password: String, harmless: String) {
    let _ = SQLStatementCursor(database: database, sql: "", arguments: [password]) // BAD
    let _ = SQLStatementCursor(database: database, sql: "", arguments: [password], prepFlags: 0) // BAD
    let _ = SQLStatementCursor(database: database, sql: "", arguments: [harmless]) // GOOD
    let _ = SQLStatementCursor(database: database, sql: "", arguments: [harmless], prepFlags: 0) // GOOD
}

func testTableRecord(password: String, harmless: String) {
    let _ = TableRecord.select(sql: "", arguments: [password]) // BAD
    let _ = TableRecord.select(sql: "", arguments: [harmless]) // GOOD
    let _ = TableRecord.filter(sql: "", arguments: [password]) // BAD
    let _ = TableRecord.filter(sql: "", arguments: [harmless]) // GOOD
    let _ = TableRecord.order(sql: "", arguments: [password]) // BAD
    let _ = TableRecord.order(sql: "", arguments: [harmless]) // GOOD
}

func test(row: Row, stmt: Statement, password: String, harmless: String) {
    row.fetchCursor(stmt, sql: "", arguments: [password]) // BAD
    row.fetchCursor(stmt, sql: "", arguments: [harmless]) // GOOD
    row.fetchCursor(stmt, sql: "", arguments: [password], adapter: nil) // BAD
    row.fetchCursor(stmt, sql: "", arguments: [harmless], adapter: nil) // GOOD

    row.fetchAll(stmt, sql: "", arguments: [password]) // BAD
    row.fetchAll(stmt, sql: "", arguments: [harmless]) // GOOD
    row.fetchAll(stmt, sql: "", arguments: [password], adapter: nil) // BAD
    row.fetchAll(stmt, sql: "", arguments: [harmless], adapter: nil) // GOOD

    row.fetchSet(stmt, sql: "", arguments: [password]) // BAD
    row.fetchSet(stmt, sql: "", arguments: [harmless]) // GOOD
    row.fetchSet(stmt, sql: "", arguments: [password], adapter: nil) // BAD
    row.fetchSet(stmt, sql: "", arguments: [harmless], adapter: nil) // GOOD

    row.fetchOne(stmt, sql: "", arguments: [password]) // BAD
    row.fetchOne(stmt, sql: "", arguments: [harmless]) // GOOD
    row.fetchOne(stmt, sql: "", arguments: [password], adapter: nil) // BAD
    row.fetchOne(stmt, sql: "", arguments: [harmless], adapter: nil) // GOOD
}

func test(databaseValueConvertible: DatabaseValueConvertible, stmt: Statement, password: String, harmless: String) {
    databaseValueConvertible.fetchCursor(stmt, sql: "", arguments: [password]) // BAD
    databaseValueConvertible.fetchCursor(stmt, sql: "", arguments: [harmless]) // GOOD
    databaseValueConvertible.fetchCursor(stmt, sql: "", arguments: [password], adapter: nil) // BAD
    databaseValueConvertible.fetchCursor(stmt, sql: "", arguments: [harmless], adapter: nil) // GOOD

    databaseValueConvertible.fetchAll(stmt, sql: "", arguments: [password]) // BAD
    databaseValueConvertible.fetchAll(stmt, sql: "", arguments: [harmless]) // GOOD
    databaseValueConvertible.fetchAll(stmt, sql: "", arguments: [password], adapter: nil) // BAD
    databaseValueConvertible.fetchAll(stmt, sql: "", arguments: [harmless], adapter: nil) // GOOD

    databaseValueConvertible.fetchSet(stmt, sql: "", arguments: [password]) // BAD
    databaseValueConvertible.fetchSet(stmt, sql: "", arguments: [harmless]) // GOOD
    databaseValueConvertible.fetchSet(stmt, sql: "", arguments: [password], adapter: nil) // BAD
    databaseValueConvertible.fetchSet(stmt, sql: "", arguments: [harmless], adapter: nil) // GOOD

    databaseValueConvertible.fetchOne(stmt, sql: "", arguments: [password]) // BAD
    databaseValueConvertible.fetchOne(stmt, sql: "", arguments: [harmless]) // GOOD
    databaseValueConvertible.fetchOne(stmt, sql: "", arguments: [password], adapter: nil) // BAD
    databaseValueConvertible.fetchOne(stmt, sql: "", arguments: [harmless], adapter: nil) // GOOD
}

func test(fetchableRecord: FetchableRecord, stmt: Statement, password: String, harmless: String) {
    fetchableRecord.fetchCursor(stmt, sql: "", arguments: [password]) // BAD
    fetchableRecord.fetchCursor(stmt, arguments: [password]) // BAD
    fetchableRecord.fetchCursor(stmt, sql: "", arguments: [harmless]) // GOOD
    fetchableRecord.fetchCursor(stmt, arguments: [harmless]) // GOOD
    fetchableRecord.fetchCursor(stmt, sql: "", arguments: [password], adapter: nil) // BAD
    fetchableRecord.fetchCursor(stmt, arguments: [password], adapter: nil) // BAD
    fetchableRecord.fetchCursor(stmt, sql: "", arguments: [harmless], adapter: nil) // GOOD
    fetchableRecord.fetchCursor(stmt, arguments: [harmless], adapter: nil) // GOOD

    fetchableRecord.fetchAll(stmt, sql: "", arguments: [password]) // BAD
    fetchableRecord.fetchAll(stmt, arguments: [password]) // BAD
    fetchableRecord.fetchAll(stmt, sql: "", arguments: [harmless]) // GOOD
    fetchableRecord.fetchAll(stmt, arguments: [harmless]) // GOOD
    fetchableRecord.fetchAll(stmt, sql: "", arguments: [password], adapter: nil) // BAD
    fetchableRecord.fetchAll(stmt, arguments: [password], adapter: nil) // BAD
    fetchableRecord.fetchAll(stmt, sql: "", arguments: [harmless], adapter: nil) // GOOD
    fetchableRecord.fetchAll(stmt, arguments: [harmless], adapter: nil) // GOOD

    fetchableRecord.fetchSet(stmt, sql: "", arguments: [password]) // BAD
    fetchableRecord.fetchSet(stmt, arguments: [password]) // BAD
    fetchableRecord.fetchSet(stmt, sql: "", arguments: [harmless]) // GOOD
    fetchableRecord.fetchSet(stmt, arguments: [harmless]) // GOOD
    fetchableRecord.fetchSet(stmt, sql: "", arguments: [password], adapter: nil) // BAD
    fetchableRecord.fetchSet(stmt, arguments: [password], adapter: nil) // BAD
    fetchableRecord.fetchSet(stmt, sql: "", arguments: [harmless], adapter: nil) // GOOD
    fetchableRecord.fetchSet(stmt, arguments: [harmless], adapter: nil) // GOOD

    fetchableRecord.fetchOne(stmt, sql: "", arguments: [password]) // BAD
    fetchableRecord.fetchOne(stmt, arguments: [password]) // BAD
    fetchableRecord.fetchOne(stmt, sql: "", arguments: [harmless]) // GOOD
    fetchableRecord.fetchOne(stmt, arguments: [harmless]) // GOOD
    fetchableRecord.fetchOne(stmt, sql: "", arguments: [password], adapter: nil) // BAD
    fetchableRecord.fetchOne(stmt, arguments: [password], adapter: nil) // BAD
    fetchableRecord.fetchOne(stmt, sql: "", arguments: [harmless], adapter: nil) // GOOD
    fetchableRecord.fetchOne(stmt, arguments: [harmless], adapter: nil) // GOOD
}

func test(stmt: Statement, password: String, harmless: String) {
    stmt.execute(arguments: [password]) // BAD
    stmt.execute(arguments: [harmless]) // GOOD

    stmt.setArguments([password]) // BAD
    stmt.setArguments([harmless]) // GOOD
}

func testCommonTableExpression(password: String, harmless: String) {
    let _ = CommonTableExpression(named: "", sql: "", arguments: [password]) // BAD
    let _ = CommonTableExpression(named: "", sql: "", arguments: [harmless]) // GOOD
    let _ = CommonTableExpression(named: "", columns: nil, sql: "", arguments: [password]) // BAD
    let _ = CommonTableExpression(named: "", columns: nil, sql: "", arguments: [harmless]) // GOOD
    let _ = CommonTableExpression(recursive: false, named: "", sql: "", arguments: [password]) // BAD
    let _ = CommonTableExpression(recursive: false, named: "", sql: "", arguments: [harmless]) // GOOD
    let _ = CommonTableExpression(recursive: false, named: "", columns: nil, sql: "", arguments: [password]) // BAD
    let _ = CommonTableExpression(recursive: false, named: "", columns: nil, sql: "", arguments: [harmless]) // GOOD
}
