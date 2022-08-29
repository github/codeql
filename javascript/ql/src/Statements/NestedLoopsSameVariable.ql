/**
 * @name Nested loops with same variable
 * @description Nested loops in which the iteration variable is the same for each loop are difficult
 *              to understand.
 * @kind problem
 * @problem.severity warning
 * @id js/nested-loops-with-same-variable
 * @tags maintainability
 *       correctness
 * @precision low
 */

import javascript

/**
 * Gets an iteration variable that loop `for` tests and updates.
 */
Variable getAnIterationVariable(ForStmt for, Expr upAccess) {
  result.getAnAccess().getParentExpr*() = for.getTest() and
  exists(UpdateExpr upd | upd.getParentExpr*() = for.getUpdate() |
    upAccess = upd.getOperand() and upAccess = result.getAnAccess()
  )
}

from ForStmt outer, ForStmt inner, Variable iteration, Expr upAccess
where
  inner.nestedIn(outer) and
  iteration = getAnIterationVariable(outer, _) and
  iteration = getAnIterationVariable(inner, upAccess)
select inner.getTest(), "Nested for statement uses loop variable $@ of enclosing $@.", upAccess,
  iteration.getName(), outer, "for statement"
