/**
 * @name Test for default switch cases
 */

import csharp

from Method m, SwitchStmt s
where s.getEnclosingCallable() = m
select m, s.getDefaultCase() as c, c.getLocation().getStartLine()
