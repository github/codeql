/**
 * @name Test for yield returns
 */

import csharp

from Method m, YieldReturnStmt yr
where
  yr.getEnclosingCallable() = m and
  m.getName() = "Range"
select 1
