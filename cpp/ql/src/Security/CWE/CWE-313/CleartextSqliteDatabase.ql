/**
 * @name Cleartext storage of sensitive information in an SQLite database
 * @description Storing sensitive information in a non-encrypted
 *              database can expose it to an attacker.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @id cpp/cleartext-storage-database
 * @tags security
 *       external/cwe/cwe-313
 */

import cpp
import semmle.code.cpp.security.SensitiveExprs
import semmle.code.cpp.dataflow.TaintTracking
import DataFlow::PathGraph

class SqliteFunctionCall extends FunctionCall {
  SqliteFunctionCall() { this.getTarget().getName().matches("sqlite%") }

  Expr getASource() { result = this.getAnArgument() }
}

predicate sqlite_encryption_used() {
  any(StringLiteral l).getValue().toLowerCase().matches("pragma key%") or
  any(StringLiteral l).getValue().toLowerCase().matches("%attach%database%key%") or
  any(FunctionCall fc).getTarget().getName().matches("sqlite%\\_key\\_%")
}

/**
 * A taint flow configuration for flow from a sensitive expression to a `SqliteFunctionCall` sink.
 */
class FromSensitiveConfiguration extends TaintTracking::Configuration {
  FromSensitiveConfiguration() { this = "FromSensitiveConfiguration" }

  override predicate isSource(DataFlow::Node source) { source.asExpr() instanceof SensitiveExpr }

  override predicate isSink(DataFlow::Node sink) {
    any(SqliteFunctionCall c).getASource() = sink.asExpr() and
    not sqlite_encryption_used()
  }

  override predicate isSanitizer(DataFlow::Node node) {
    node.asExpr().getUnspecifiedType() instanceof IntegralType
  }
}

from
  FromSensitiveConfiguration config, SensitiveExpr sensitive, DataFlow::PathNode source,
  DataFlow::PathNode sink, SqliteFunctionCall sqliteCall
where
  config.hasFlowPath(source, sink) and
  source.getNode().asExpr() = sensitive and
  sqliteCall.getASource() = sink.getNode().asExpr()
select sqliteCall, source, sink, "This SQLite call may store $@ in a non-encrypted SQLite database",
  sensitive, "sensitive information"
