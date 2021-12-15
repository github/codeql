/**
 * @name Comparison is constant
 * @description The result of the comparison is always the same.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cs/constant-comparison
 * @tags correctness
 */

import csharp
import semmle.code.csharp.commons.Assertions
import semmle.code.csharp.commons.Constants

from ComparisonOperation cmp, boolean value
where
  isConstantComparison(cmp, value) and
  not isConstantCondition(cmp, _) and // Avoid overlap with cs/constant-condition
  not isExprInAssertion(cmp)
select cmp, "This comparison is always " + value + "."
