/**
 * @name Improper validation of code-specified array index
 * @description Using a code-specified value as an index to an array, without
 *              proper validation, can lead to index out of bound exceptions.
 * @kind path-problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/improper-validation-of-array-index-code-specified
 * @tags security
 *       external/cwe/cwe-129
 */

import java
import ArraySizing
import BoundingChecks
import DataFlow::PathGraph

class BoundedFlowSourceConf extends DataFlow::Configuration {
  BoundedFlowSourceConf() { this = "BoundedFlowSource" }

  override predicate isSource(DataFlow::Node source) { source instanceof BoundedFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(CheckableArrayAccess arrayAccess | arrayAccess.canThrowOutOfBounds(sink.asExpr()))
  }
}

from
  DataFlow::PathNode source, DataFlow::PathNode sink, BoundedFlowSource boundedsource,
  CheckableArrayAccess arrayAccess
where
  arrayAccess.canThrowOutOfBounds(sink.getNode().asExpr()) and
  boundedsource = source.getNode() and
  any(BoundedFlowSourceConf conf).hasFlowPath(source, sink) and
  boundedsource != sink.getNode() and
  not (
    (
      // The input has a lower bound.
      boundedsource.lowerBound() >= 0
      or
      // There is a condition dominating this expression ensuring that the index is >= 0.
      lowerBound(arrayAccess.getIndexExpr()) >= 0
    ) and
    (
      // The input has an upper bound, and the array has a fixed size, and that fixed size is less.
      boundedsource.upperBound() < fixedArraySize(arrayAccess)
      or
      // There is a condition dominating this expression that ensures the index is less than the length.
      lessthanLength(arrayAccess)
    )
  ) and
  // Exclude cases where the array is assigned multiple times. The checks for bounded flow sources
  // can use fixed sizes for arrays, but this doesn't work well when the array is initialized to zero
  // and subsequently reassigned or grown.
  count(arrayAccess.getArray().(VarAccess).getVariable().getAnAssignedValue()) = 1
select arrayAccess.getIndexExpr(), source, sink,
  "$@ flows to the index used in this array access, and may cause the operation to throw an ArrayIndexOutOfBoundsException.",
  boundedsource, boundedsource.getDescription()
