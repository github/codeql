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
 *  Gets a field of the class `c`, or of another class contained in `c`.
 */
Field getRecField(Class c) {
  result = c.getAField() or
  result = getRecField(c.getAField().getUnspecifiedType().stripType())
}

/**
 * Holds if `source` is a use of a sensitive expression `sensitive`, or
 * if `source` is the output argument (with a sensitive name) of a function.
 */
predicate isSourceImpl(DataFlow::Node source, SensitiveExpr sensitive) {
  [source.asExpr(), source.asDefiningArgument()] = sensitive
}

/** Holds if `sink` is an argument to an Sqlite function call `c`. */
predicate isSinkImpl(DataFlow::Node sink, SqliteFunctionCall c) {
  [sink.asExpr(), sink.asIndirectExpr()] = c.getASource()
}

/**
 * A taint flow configuration for flow from a sensitive expression to a `SqliteFunctionCall` sink.
 */
class FromSensitiveConfiguration extends TaintTracking::Configuration {
  FromSensitiveConfiguration() { this = "FromSensitiveConfiguration" }

  override predicate isSource(DataFlow::Node source) { isSourceImpl(source, _) }

  override predicate isSink(DataFlow::Node sink) {
    isSinkImpl(sink, _) and
    not sqlite_encryption_used()
  }

  override predicate isSanitizer(DataFlow::Node node) {
    node.asExpr().getUnspecifiedType() instanceof IntegralType
  }

  override predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet content) {
    // flow out from fields at the sink (only).
    this.isSink(node) and
    // constrain `content` to a field inside the node.
    exists(Class c |
      node.getType().getUnspecifiedType().stripType() = c and
      content.(DataFlow::FieldContent).getField() = getRecField(c)
    )
    or
    // any default implicit reads
    super.allowImplicitRead(node, content)
  }
}

from
  FromSensitiveConfiguration config, SensitiveExpr sensitive, DataFlow::PathNode source,
  DataFlow::PathNode sink, SqliteFunctionCall sqliteCall
where
  config.hasFlowPath(source, sink) and
  isSourceImpl(source.getNode(), sensitive) and
  isSinkImpl(sink.getNode(), sqliteCall)
select sqliteCall, source, sink,
  "This SQLite call may store $@ in a non-encrypted SQLite database.", sensitive,
  "sensitive information"
