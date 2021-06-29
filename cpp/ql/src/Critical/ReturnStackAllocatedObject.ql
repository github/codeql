/**
 * @name Pointer to stack object used as return value
 * @description Using a pointer to stack memory after the function has returned gives undefined results.
 * @kind problem
 * @id cpp/return-stack-allocated-object
 * @problem.severity warning
 * @security-severity 2.1
 * @tags reliability
 *       security
 *       external/cwe/cwe-562
 * @deprecated This query is not suitable for production use and has been deprecated. Use
 *             cpp/return-stack-allocated-memory instead.
 */

import semmle.code.cpp.pointsto.PointsTo

class ReturnPointsToExpr extends PointsToExpr {
  override predicate interesting() {
    exists(ReturnStmt ret | ret.getExpr().getFullyConverted() = this) and
    pointerValue(this)
  }

  ReturnStmt getReturnStmt() { result.getExpr().getFullyConverted() = this }
}

from ReturnPointsToExpr ret, StackVariable local, float confidence
where
  ret.pointsTo() = local and
  ret.getReturnStmt().getEnclosingFunction() = local.getFunction() and
  confidence = ret.confidence() and
  confidence > 0.01
select ret,
  "This may return a pointer to '" + local.getName() + "' (declared on line " +
    local.getADeclarationLocation().getStartLine().toString() + "), which is stack allocated."
