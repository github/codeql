/**
 * @name Nested loops with same variable
 * @description Nested loops in which the iteration variable is the same for each loop are difficult
 *              to understand.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/nested-loops-with-same-variable
 * @tags maintainability
 *       correctness
 *       logic
 */

import java

from ForStmt inner, Variable iteration, ForStmt outer
where
  iteration = inner.getAnIterationVariable() and
  iteration = outer.getAnIterationVariable() and
  inner.getEnclosingStmt+() = outer and
  inner.getBasicBlock().getABBSuccessor+() = outer.getCondition().getBasicBlock()
select inner.getCondition(), "Nested for statement uses loop variable $@ of enclosing $@.",
  iteration, iteration.getName(), outer, "for statement"
