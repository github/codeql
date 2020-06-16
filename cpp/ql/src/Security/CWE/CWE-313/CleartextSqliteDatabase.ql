/**
 * @name Cleartext storage of sensitive information in an SQLite database
 * @description Storing sensitive information in a non-encrypted
 *              database can expose it to an attacker.
 * @kind path-problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/cleartext-storage-database
 * @tags security
 *       external/cwe/cwe-313
 */

import cpp
import semmle.code.cpp.security.SensitiveExprs
import semmle.code.cpp.security.TaintTracking
import TaintedWithPath

class UserInputIsSensitiveExpr extends SecurityOptions {
  override predicate isUserInput(Expr expr, string cause) {
    expr instanceof SensitiveExpr and cause = "sensitive information"
  }
}

class SqliteFunctionCall extends FunctionCall {
  SqliteFunctionCall() { this.getTarget().getName().matches("sqlite%") }

  Expr getASource() { result = this.getAnArgument() }
}

predicate sqlite_encryption_used() {
  any(StringLiteral l).getValue().toLowerCase().regexpMatch("pragma key.*") or
  any(StringLiteral l).getValue().toLowerCase().matches("%attach%database%key%") or
  any(FunctionCall fc).getTarget().getName().matches("sqlite%\\_key\\_%")
}

class Configuration extends TaintTrackingConfiguration {
  override predicate isSink(Element taintedArg) {
    exists(SqliteFunctionCall sqliteCall |
      taintedArg = sqliteCall.getASource() and
      not sqlite_encryption_used()
    )
  }
}

from
  SensitiveExpr taintSource, Expr taintedArg, SqliteFunctionCall sqliteCall, PathNode sourceNode,
  PathNode sinkNode
where
  taintedWithPath(taintSource, taintedArg, sourceNode, sinkNode) and
  taintedArg = sqliteCall.getASource()
select sqliteCall, sourceNode, sinkNode,
  "This SQLite call may store $@ in a non-encrypted SQLite database", taintSource,
  "sensitive information"
