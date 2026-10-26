/**
 * @name Futile conditional
 * @description If-statement with an empty then-branch and no else-branch.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id cs/useless-if-statement
 * @tags quality
 *       maintainability
 *       readability
 *       useless-code
 */

import csharp

predicate emptyStmt(Stmt s) {
  s instanceof EmptyStmt
  or
  s =
    any(BlockStmt bs |
      bs.getNumberOfStmts() = 0 and
      not any(CommentBlock cb).getParent() = bs
      or
      bs.getNumberOfStmts() = 1 and
      emptyStmt(bs.getStmt(0))
    )
}

from IfStmt ifstmt
where
  emptyStmt(ifstmt.getThen()) and
  (not exists(ifstmt.getElse()) or emptyStmt(ifstmt.getElse()))
select ifstmt, "If-statement with an empty then-branch and no else-branch."
