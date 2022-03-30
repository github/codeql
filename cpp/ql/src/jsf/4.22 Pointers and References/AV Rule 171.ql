/**
 * @name AV Rule 171
 * @description Relational operations shall not be applied to pointer types except where
 *              both operands are of the same type and point to or into the same object.
 * @kind problem
 * @id cpp/jsf/av-rule-171
 * @problem.severity error
 * @tags correctness
 *       external/jsf
 */

import cpp
import semmle.code.cpp.pointsto.PointsTo

class PointerInComparison extends PointsToExpr {
  override predicate interesting() {
    exists(ComparisonOperation comp | comp.getAChild() = this) and
    pointerValue(this)
  }

  ComparisonOperation getComparison() { result.getAChild() = this }
}

predicate mayBeCompared(PointerInComparison p, PointerInComparison q) {
  p.getUnderlyingType() = q.getUnderlyingType() and
  p.pointsTo() = q.pointsTo()
  or
  // TODO: should handle null pointers (p and q can only be compared if either both or none can be null)
  // for now, just allow comparisons with null
  p.getValue() = "0"
  or
  q.getValue() = "0"
}

from PointerInComparison p, PointerInComparison q
where
  p.getComparison() = q.getComparison() and
  not mayBeCompared(p, q)
select p.getComparison(),
  "AV Rule 171: Relational operators shall not be applied to pointer types except in very specific circumstances."
