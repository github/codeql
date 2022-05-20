/**
 * @name Test for switch cases
 */

import csharp

from Method m, SwitchStmt s
where s.getEnclosingCallable() = m
select m, s.getAConstCase() as c, c.getLocation().getStartLine()
