/**
 * @name Test for events
 */

import csharp

from RemoveEventAccessor a
where
  a.getStatementBody().getNumberOfStmts() = 1 and
  a.getStatementBody().getStmt(0) instanceof ExprStmt
select a
