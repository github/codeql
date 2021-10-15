/**
 * @name Test yielded expressions
 */

import csharp

from YieldReturnStmt yr, LocalVariable i
where
  yr.getExpr() = i.getAnAccess() and
  i.getName() = "i"
select 1
