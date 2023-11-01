/**
 * @name Empty 'if' statement
 * @description Finds 'if' statements where the "then" branch is empty and no
 *              "else" branch exists.
 * @id swift/examples/empty-if
 * @tags example
 */

import swift

from IfStmt ifStmt
where
  ifStmt.getThen().(BraceStmt).getNumberOfElements() = 0 and
  not exists(ifStmt.getElse())
select ifStmt, "This 'if' statement is redundant."
