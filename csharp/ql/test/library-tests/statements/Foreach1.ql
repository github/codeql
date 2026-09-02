/**
 * @name Test for well-formed foreachs
 */

import csharp

where forall(ForEachStmt s | exists(s.getBody()) and exists(s.getIterableExpr()))
select 1
