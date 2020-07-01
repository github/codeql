/**
 * @name Nested loops with same variable
 * @description When a nested loop uses the same iteration variable as its outer loop, the
 *   behavior of the outer loop easily becomes difficult to understand as the
 *   inner loop will affect its control flow. It is likely to be a typo.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/nested-loops-with-same-variable
 * @tags maintainability
 *       correctness
 */

import NestedLoopSameVar

from ForStmt inner, Variable iteration, ForStmt outer
where nestedForViolation(inner, iteration, outer)
select inner.getCondition(), "Nested for statement uses loop variable $@ of enclosing $@.",
  iteration, iteration.getName(), outer, "for statement"
