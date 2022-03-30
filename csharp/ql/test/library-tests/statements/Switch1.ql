/**
 * @name Test for well-formed switches
 */

import csharp

from SwitchStmt s
select s, s.getCondition(), count(s.getAConstCase()), count(s.getDefaultCase()),
  count(s.getAChildStmt())
