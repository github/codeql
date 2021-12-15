/**
 * @name Nested loops with same variable reused after inner loop body
 * @description Redefining a variable in an inner loop and then using
 *              the variable in an outer loop causes unexpected behavior.
 * @kind problem
 * @tags maintainability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision very-high
 * @id py/nested-loops-with-same-variable-reused
 */

import python

predicate loop_variable_ssa(For f, Variable v, SsaVariable s) {
  f.getTarget().getAFlowNode() = s.getDefinition() and v = s.getVariable()
}

predicate variableUsedInNestedLoops(For inner, For outer, Variable v, Name n) {
  /* Ignore cases where there is no use of the variable or the only use is in the inner loop. */
  outer.contains(n) and
  not inner.contains(n) and
  /* Only treat loops in body as inner loops. Loops in the else clause are ignored. */
  outer.getBody().contains(inner) and
  exists(SsaVariable s |
    loop_variable_ssa(inner, v, s.getAnUltimateDefinition()) and
    loop_variable_ssa(outer, v, _) and
    s.getAUse().getNode() = n
  )
}

from For inner, For outer, Variable v, Name n
where variableUsedInNestedLoops(inner, outer, v, n)
select inner, "Nested for statement $@ loop variable '" + v.getId() + "' of enclosing $@.", n,
  "uses", outer, "for statement"
