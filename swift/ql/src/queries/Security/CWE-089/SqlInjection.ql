/**
 * @name Database query built from user-controlled sources
 * @description Building a database query from user-controlled sources is vulnerable to insertion of malicious code by the user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @id swift/sql-injection
 * @tags security
 *       external/cwe/cwe-089
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.dataflow.FlowSources
import DataFlow::PathGraph

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

/**
 * A taint configuration for tainted data that reaches a SQL sink.
 */
class SqlInjectionConfig extends TaintTracking::Configuration {
  SqlInjectionConfig() { this = "SqlInjectionConfig" }

  override predicate isSource(DataFlow::Node node) { node instanceof FlowSource }

  override predicate isSink(DataFlow::Node node) { node instanceof SqlSink }
}

from SqlInjectionConfig config, DataFlow::PathNode sourceNode, DataFlow::PathNode sinkNode
where config.hasFlowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode, "This query depends on a $@.",
  sourceNode.getNode(), "user-provided value"
