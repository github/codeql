/**
 * @name Off-by-one comparison against container length
 * @description The index is compared to be less than or equal to the container length, then used
 *              in an array indexing operation that could be out of bounds.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/index-out-of-bounds
 * @tags reliability
 *       correctness
 *       logic
 *      external/cwe/cwe-193
 */

import csharp
import semmle.code.csharp.controlflow.Guards
import semmle.code.csharp.commons.ComparisonTest

/** A comparison of an index variable with the length of an array. */
class IndexGuard extends ComparisonTest {
  VariableAccess indexAccess;
  Variable array;

  IndexGuard() {
    this.getFirstArgument() = indexAccess and
    this.getSecondArgument() =
      any(PropertyAccess lengthAccess |
        lengthAccess.getQualifier() = array.getAnAccess() and
        lengthAccess.getTarget().hasName("Length")
      )
  }

  /** Holds if this comparison applies to array `arr` and index `ind`. */
  predicate controls(Variable arr, Variable ind) {
    arr = array and
    ind.getAnAccess() = indexAccess
  }

  /** Holds if this comparison guards `expr`. */
  predicate guards(GuardedExpr expr, boolean condition) {
    expr.isGuardedBy(this.getExpr(), indexAccess, condition)
  }

  /** Holds if this comparison is an incorrect `<=` or equivalent. */
  predicate isIncorrect() { this.getComparisonKind().isLessThanEquals() }
}

from
  IndexGuard incorrectGuard, Variable array, Variable index, ElementAccess ea,
  GuardedExpr indexAccess
where
  // Look for `index <= array.Length` or `array.Length >= index`
  incorrectGuard.controls(array, index) and
  incorrectGuard.isIncorrect() and
  // Look for `array[index]`
  ea.getQualifier() = array.getAnAccess() and
  ea.getIndex(0) = indexAccess and
  indexAccess = index.getAnAccess() and
  // Where the index access is guarded by the comparison
  incorrectGuard.guards(indexAccess, true) and
  // And there are no other guards
  not exists(IndexGuard validGuard |
    not validGuard.isIncorrect() and
    validGuard.controls(array, index) and
    validGuard.guards(indexAccess, _)
  )
select incorrectGuard,
  "Off-by-one index comparison against length leads to possible out of bounds $@.", ea,
  ea.toString()
