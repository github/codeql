/**
 * @name Test for empty blocks
 */

import csharp

from Method m
where
  m.getName() = "Main" and
  count(BlockStmt b | b.getEnclosingCallable() = m and b.isEmpty()) = 2
select m
