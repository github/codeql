/**
 * @name Test for locks
 */

import csharp

where forall(LockStmt s | exists(s.getExpr()) and exists(s.getBlock()))
select 1
