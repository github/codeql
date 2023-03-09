/**
 * Provides classes and predicates for reasoning about database
 * queries built from user-controlled sources (that is, SQL injection
 * vulnerabilities).
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.ExternalFlow

/**
 * A dataflow sink for SQL injection vulnerabilities.
 */
abstract class SqlInjectionSink extends DataFlow::Node { }

/**
 * A sanitizer for SQL injection vulnerabilities.
 */
abstract class SqlInjectionSanitizer extends DataFlow::Node { }

/**
 * A unit class for adding additional taint steps.
 */
class SqlInjectionAdditionalTaintStep extends Unit {
  abstract predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo);
}

/**
 * A default SQL injection sink for the sqlite3 C API.
 */
private class CApiDefaultSqlInjectionSink extends SqlInjectionSink {
  CApiDefaultSqlInjectionSink() {
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
 * A default SQL injection sink for the `SQLite.swift` library.
 */
private class SQLiteSwiftDefaultSqlInjectionSink extends SqlInjectionSink {
  SQLiteSwiftDefaultSqlInjectionSink() {
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

/**
 * A default SQL injection sink for the GRDB library.
 */
private class GrdbDefaultSqlInjectionSink extends SqlInjectionSink {
  GrdbDefaultSqlInjectionSink() {
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

/**
 * A sink defined in a CSV model.
 */
private class DefaultSqlInjectionSink extends SqlInjectionSink {
  DefaultSqlInjectionSink() { sinkNode(this, "sql") }
}
