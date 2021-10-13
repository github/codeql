/**
 * @name Duplicate 'if' condition
 * @description If two conditions in an 'if'-'else if' chain are identical, the
 *              second condition will never hold.
 * @kind problem
 * @problem.severity warning
 * @id js/duplicate-condition
 * @tags maintainability
 *       correctness
 *       external/cwe/cwe-561
 * @precision very-high
 */

import Clones

/** Gets the `i`th condition in the `if`-`else if` chain starting at `stmt`. */
Expr getCondition(IfStmt stmt, int i) {
  i = 0 and result = stmt.getCondition()
  or
  result = getCondition(stmt.getElse(), i - 1)
}

/**
 * A detector for duplicated `if` conditions in the same `if`-`else if` chain.
 */
class DuplicateIfCondition extends StructurallyCompared {
  DuplicateIfCondition() { this = getCondition(_, 0) }

  override Expr candidate() {
    exists(IfStmt stmt, int j | this = getCondition(stmt, 0) |
      j > 0 and result = getCondition(stmt, j)
    )
  }
}

from DuplicateIfCondition e, Expr f
where e.same(f)
select f, "This condition is a duplicate of $@.", e, e.toString()
