/**
 * @name Empty 'if' statement
 * @description Finds 'if' statements where the "then" branch is empty and no
 *              "else" branch exists.
 * @id rust/examples/empty-if
 * @tags example
 */

import rust

// find 'if' statements...
from IfExpr ifExpr
where
  // where the 'then' branch is empty
  ifExpr.getThen().(BlockExpr).getStmtList().getNumberOfStmtOrExpr() = 0 and
  // and no 'else' branch exists
  not exists(ifExpr.getElse())
select ifExpr, "This 'if' expression is redundant."
