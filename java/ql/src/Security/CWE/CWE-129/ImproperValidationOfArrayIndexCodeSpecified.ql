/**
 * @name Improper validation of code-specified array index
 * @description Using a code-specified value as an index to an array, without
 *              proper validation, can lead to index out of bound exceptions.
 * @kind path-problem
 * @problem.severity recommendation
 * @security-severity 8.8
 * @precision medium
 * @id java/improper-validation-of-array-index-code-specified
 * @tags security
 *       external/cwe/cwe-129
 */

import java
import semmle.code.java.security.internal.ArraySizing
import semmle.code.java.security.internal.BoundingChecks
import semmle.code.java.security.ImproperValidationOfArrayIndexCodeSpecifiedQuery
import BoundedFlowSourceFlow::PathGraph

from
  BoundedFlowSourceFlow::PathNode source, BoundedFlowSourceFlow::PathNode sink,
  BoundedFlowSource boundedsource, CheckableArrayAccess arrayAccess
where
  arrayAccess.canThrowOutOfBounds(sink.getNode().asExpr()) and
  boundedsource = source.getNode() and
  BoundedFlowSourceFlow::flowPath(source, sink) and
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
