/**
 * @name Test for well-formed whiles
 */

import csharp

where forall(WhileStmt s | exists(s.getCondition()) and exists(s.getBody()))
select 1
