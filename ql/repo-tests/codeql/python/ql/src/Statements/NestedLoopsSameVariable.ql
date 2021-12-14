/**
 * @name Nested loops with same variable
 * @description Nested loops in which the target variable is the same for each loop make
 *              the behavior of the loops difficult to understand.
 * @kind problem
 * @tags maintainability
 *       correctness
 * @problem.severity recommendation
 * @sub-severity high
 * @precision very-high
 * @id py/nested-loops-with-same-variable
 */

import python

predicate loop_variable(For f, Variable v) { f.getTarget().defines(v) }

predicate variableUsedInNestedLoops(For inner, For outer, Variable v) {
  /* Only treat loops in body as inner loops. Loops in the else clause are ignored. */
  outer.getBody().contains(inner) and
  loop_variable(inner, v) and
  loop_variable(outer, v) and
  /* Ignore cases where there is no use of the variable or the only use is in the inner loop */
  exists(Name n | n.uses(v) and outer.contains(n) and not inner.contains(n))
}

from For inner, For outer, Variable v
where variableUsedInNestedLoops(inner, outer, v)
select inner, "Nested for statement uses loop variable '" + v.getId() + "' of enclosing $@.", outer,
  "for statement"
