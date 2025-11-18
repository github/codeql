/**
 * @name Empty 'if' expression
 * @description Finds 'if' expressions where the "then" branch is empty and no
 *              "else" branch exists.
 * @id rust/examples/empty-if
 * @tags example
 */

import rust

// find 'if' expressions...
from IfExpr ifExpr
where
  // where the 'then' branch is empty
  ifExpr.getThen().getStmtList().getNumberOfStmtOrExpr() = 0 and
  // and no 'else' branch exists
  not ifExpr.hasElse()
select ifExpr, "This 'if' expression is redundant."
