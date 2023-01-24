/**
 * Provides classes and predicates for reasoning about database
 * queries built from user-controlled sources (that is, SQL injection
 * vulnerabilities).
 */

import swift
import codeql.swift.dataflow.DataFlow

/**
 * A `DataFlow::Node` that is a sink for a SQL string to be executed.
 */
abstract class SqlSink extends DataFlow::Node { }

/**
 * A sink for the sqlite3 C API.
 */
class CApiSqlSink extends SqlSink {
  CApiSqlSink() {
    // `sqlite3_exec` and variants of `sqlite3_prepare`.
    exists(CallExpr call |
      call.getStaticTarget()
          .(FreeFunctionDecl)
          .hasName([
              "sqlite3_exec(_:_:_:_:_:)", "sqlite3_prepare(_:_:_:_:_:)",
              "sqlite3_prepare_v2(_:_:_:_:_:)", "sqlite3_prepare_v3(_:_:_:_:_:_:)",
              "sqlite3_prepare16(_:_:_:_:_:)", "sqlite3_prepare16_v2(_:_:_:_:_:)",
              "sqlite3_prepare16_v3(_:_:_:_:_:_:)"
            ]) and
      call.getArgument(1).getExpr() = this.asExpr()
    )
  }
}

/**
 * A sink for the SQLite.swift library.
 */
class SQLiteSwiftSqlSink extends SqlSink {
  SQLiteSwiftSqlSink() {
    // Variants of `Connection.execute`, `connection.prepare` and `connection.scalar`.
    exists(CallExpr call |
      call.getStaticTarget()
          .(MethodDecl)
          .hasQualifiedName("Connection",
            ["execute(_:)", "prepare(_:_:)", "run(_:_:)", "scalar(_:_:)"]) and
      call.getArgument(0).getExpr() = this.asExpr()
    )
    or
    // String argument to the `Statement` constructor.
    exists(CallExpr call |
      call.getStaticTarget().(MethodDecl).hasQualifiedName("Statement", "init(_:_:)") and
      call.getArgument(1).getExpr() = this.asExpr()
    )
  }
}

/** A sink for the GRDB library. */
class GrdbSqlSink extends SqlSink {
  GrdbSqlSink() {
    exists(CallExpr call, MethodDecl method |
      call.getStaticTarget() = method and
      call.getArgument(0).getExpr() = this.asExpr()
    |
      method
          .hasQualifiedName("Database",
            [
              "allStatements(sql:arguments:)", "cachedStatement(sql:)",
              "internalCachedStatement(sql:)", "execute(sql:arguments:)", "makeStatement(sql:)",
              "makeStatement(sql:prepFlags:)"
            ])
      or
      method
          .hasQualifiedName("SQLRequest",
            [
              "init(stringLiteral:)", "init(unicodeScalarLiteral:)",
              "init(extendedGraphemeClusterLiteral:)", "init(stringInterpolation:)",
              "init(sql:arguments:adapter:cached:)"
            ])
      or
      method
          .hasQualifiedName("SQL",
            [
              "init(stringLiteral:)", "init(unicodeScalarLiteral:)",
              "init(extendedGraphemeClusterLiteral:)", "init(stringInterpolation:)",
              "init(sql:arguments:)", "append(sql:arguments:)"
            ])
      or
      method
          .hasQualifiedName("TableDefinition", ["column(sql:)", "check(sql:)", "constraint(sql:)"])
      or
      method.hasQualifiedName("TableAlteration", "addColumn(sql:)")
      or
      method
          .hasQualifiedName("ColumnDefinition",
            ["check(sql:)", "defaults(sql:)", "generatedAs(sql:_:)"])
      or
      method
          .hasQualifiedName("TableRecord",
            [
              "select(sql:arguments:)", "select(sql:arguments:as:)", "filter(sql:arguments:)",
              "order(sql:arguments:)"
            ])
      or
      method.hasQualifiedName("StatementCache", "statement(_:)")
    )
    or
    exists(CallExpr call, MethodDecl method |
      call.getStaticTarget() = method and
      call.getArgument(1).getExpr() = this.asExpr()
    |
      method
          .hasQualifiedName(["Row", "DatabaseValueConvertible"],
            [
              "fetchCursor(_:sql:arguments:adapter:)", "fetchAll(_:sql:arguments:adapter:)",
              "fetchSet(_:sql:arguments:adapter:)", "fetchOne(_:sql:arguments:adapter:)"
            ])
      or
      method.hasQualifiedName("SQLStatementCursor", "init(database:sql:arguments:prepFlags:)")
    )
    or
    exists(CallExpr call, MethodDecl method |
      call.getStaticTarget() = method and
      call.getArgument(3).getExpr() = this.asExpr()
    |
      method
          .hasQualifiedName("CommonTableExpression", "init(recursive:named:columns:sql:arguments:)")
    )
  }
}
