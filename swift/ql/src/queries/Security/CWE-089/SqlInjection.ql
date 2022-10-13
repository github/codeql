/**
 * @name TODO
 * @description TODO
 * @kind path-problem
 * @problem.severity TODO
 * @security-severity TODO
 * @precision TODO
 * @id swift/sql-injection
 * @tags security
 *       external/cwe/cwe-089
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import DataFlow::PathGraph

/**
 * A `DataFlow::Node` that is a sink for an SQL string to be executed.
 */
abstract class SqlSink extends DataFlow::Node { }

/**
 * A sink for the sqlite3 C API.
 */
class CApiSqlSink extends SqlSink {
  CApiSqlSink() {
    // `sqlite3_exec` and variants of `sqlite3_prepare`.
    exists(AbstractFunctionDecl f, CallExpr call |
      f.getName() =
        [
          "sqlite3_exec(_:_:_:_:_:)", "sqlite3_prepare(_:_:_:_:_:)",
          "sqlite3_prepare_v2(_:_:_:_:_:)", "sqlite3_prepare_v3(_:_:_:_:_:)",
          "sqlite3_prepare16(_:_:_:_:_:)", "sqlite3_prepare16_v2(_:_:_:_:_:)",
          "sqlite3_prepare16_v3(_:_:_:_:_:)"
        ] and
      call.getStaticTarget() = f and
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
    exists(ClassDecl c, AbstractFunctionDecl f, CallExpr call |
      c.getName() = "Connection" and
      c.getAMember() = f and
      f.getName() = ["execute(_:)", "prepare(_:_:)", "run(_:_:)", "scalar(_:_:)"] and
      call.getStaticTarget() = f and
      call.getArgument(0).getExpr() = this.asExpr()
    )
    or
    // String argument to the `Statement` constructor.
    exists(ClassDecl c, AbstractFunctionDecl f, CallExpr call |
      c.getName() = "Statement" and
      c.getAMember() = f and
      f.getName() = "init(_:_:)" and
      call.getStaticTarget() = f and
      call.getArgument(1).getExpr() = this.asExpr()
    )
  }
}

from SqlSink s
select s
