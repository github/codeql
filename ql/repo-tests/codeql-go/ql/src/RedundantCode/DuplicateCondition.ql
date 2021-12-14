/**
 * @name Duplicate 'if' condition
 * @description If two conditions in an 'if'-'else if' chain are identical, the
 *              second condition will never hold.
 * @kind problem
 * @problem.severity error
 * @id go/duplicate-condition
 * @tags maintainability
 *       correctness
 *       external/cwe/cwe-561
 * @precision very-high
 */

import go

/** Gets the `i`th condition in the `if`-`else if` chain starting at `stmt`. */
Expr getCondition(IfStmt stmt, int i) {
  i = 0 and result = stmt.getCond()
  or
  exists(IfStmt elsif | elsif = stmt.getElse() |
    not exists(elsif.getInit()) and
    result = getCondition(stmt.getElse(), i - 1)
  )
}

/** Gets the global value number of `e`, which is the `i`th condition of `is`. */
GVN conditionGVN(IfStmt is, int i, Expr e) {
  e = getCondition(is, i) and result = e.getGlobalValueNumber()
}

from IfStmt is, Expr e, Expr f, int i, int j
where conditionGVN(is, i, e) = conditionGVN(is, j, f) and i < j
select f, "This condition is a duplicate of $@.", e, "an earlier condition"
