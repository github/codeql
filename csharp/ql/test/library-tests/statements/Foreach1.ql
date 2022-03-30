/**
 * @name Test for well-formed foreachs
 */

import csharp

where forall(ForeachStmt s | exists(s.getBody()) and exists(s.getIterableExpr()))
select 1
