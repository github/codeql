/**
 * @name Comparison of identical values
 * @description When the same variable occurs on both sides of a comparison
 *              operator, the behavior is always constant, and probably not
 *              what it was intended to be.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cs/comparison-of-identical-expressions
 * @tags reliability
 */

import csharp
import semmle.code.csharp.commons.Assertions
import semmle.code.csharp.commons.ComparisonTest
import semmle.code.csharp.commons.Constants

predicate isBoxingTestCase(StaticEqualsCallComparisonTest ct) {
  ct.isReferenceEquals() and
  exists(TypeParameter tp |
    tp = ct.getFirstArgument().stripCasts().getType() and
    not tp.isValueType() and
    not tp.isRefType()
  )
}

predicate isMutatingOperation(Expr e) {
  e.(MethodCall).getTarget().hasName("Pop")
  or
  e.(MethodCall).getTarget().hasName("Push")
  or
  e instanceof MutatorOperation
}

from ComparisonTest ct, Expr e, string msg
where
  comparesIdenticalValues(ct) and
  e = ct.getExpr() and
  not isBoxingTestCase(ct) and
  (
    exists(string m | comparesIdenticalValuesNan(ct, m) |
      msg = "Comparison is equivalent to using " + m
    )
    or
    not comparesIdenticalValuesNan(ct, _) and msg = "Comparison of identical values."
  ) and
  not isMutatingOperation(ct.getAnArgument().getAChild*()) and
  not isConstantCondition(e, _) and // Avoid overlap with cs/constant-condition
  not isConstantComparison(e, _) and // Avoid overlap with cs/constant-comparison
  not isExprInAssertion(e)
select ct, msg
