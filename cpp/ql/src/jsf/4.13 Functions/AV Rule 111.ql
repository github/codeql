/**
 * @name Return stack-allocated object
 * @description A function must not return a pointer or reference to a non-static local object.
 * @kind problem
 * @id cpp/jsf/av-rule-111
 * @problem.severity error
 * @tags correctness
 *       reliability
 *       external/jsf
 */

import semmle.code.cpp.pointsto.PointsTo

class ReturnPointsToExpr extends PointsToExpr {
  override predicate interesting() {
    exists(ReturnStmt ret | ret.getExpr() = this) and
    pointerValue(this)
  }

  ReturnStmt getReturnStmt() { result.getExpr() = this }
}

from ReturnPointsToExpr ret, StackVariable dest
where
  ret.pointsTo() = dest and
  ret.getReturnStmt().getParentStmt().getEnclosingFunction() = dest.getFunction()
select ret.getReturnStmt(),
  "AV Rule 111: A function shall not return a pointer or reference to a non-static local object."
