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
Variable getAnIterationVariable(ForStmt for) {
  result.getAnAccess().getParentExpr*() = for.getTest() and
  exists(UpdateExpr upd | upd.getParentExpr*() = for.getUpdate() |
    upd.getOperand() = result.getAnAccess()
  )
}

from ForStmt outer, ForStmt inner
where
  inner.nestedIn(outer) and
  getAnIterationVariable(outer) = getAnIterationVariable(inner)
select inner.getTest(), "This for statement uses the same loop variable as an enclosing $@.", outer,
  "for statement"
