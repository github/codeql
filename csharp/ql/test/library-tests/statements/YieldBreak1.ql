/**
 * @name Test for yield breaks
 */

import csharp

from Method m, YieldBreakStmt yr
where
  yr.getEnclosingCallable() = m and
  m.getName() = "Range"
select 1
