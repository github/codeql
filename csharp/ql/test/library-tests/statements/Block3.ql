/**
 * @name Test for indices of block children
 */

import csharp

where
  forall(BlockStmt b | forall(int n | n in [0 .. b.getNumberOfStmts() - 1] | exists(b.getChild(n))))
select 1
