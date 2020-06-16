/**
 * @name Untrusted input for a condition
 * @description Using untrusted inputs in a statement that makes a
 *              security decision makes code vulnerable to
 *              attack.
 * @kind path-problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/tainted-permissions-check
 * @tags security
 *       external/cwe/cwe-807
 */

import semmle.code.cpp.security.TaintTracking
import TaintedWithPath

predicate sensitiveCondition(Expr condition, Expr raise) {
  raisesPrivilege(raise) and
  exists(IfStmt ifstmt |
    ifstmt.getCondition() = condition and
    raise.getEnclosingStmt().getParentStmt*() = ifstmt
  )
}

class Configuration extends TaintTrackingConfiguration {
  override predicate isSink(Element tainted) { sensitiveCondition(tainted, _) }
}

/*
 * Produce an alert if there is an 'if' statement whose condition `condition`
 * is influenced by tainted data `source`, and the body contains
 * `raise` which escalates privilege.
 */

from Expr source, Expr condition, Expr raise, PathNode sourceNode, PathNode sinkNode
where
  taintedWithPath(source, condition, sourceNode, sinkNode) and
  sensitiveCondition(condition, raise)
select condition, sourceNode, sinkNode, "Reliance on untrusted input $@ to raise privilege at $@",
  source, source.toString(), raise, raise.toString()
