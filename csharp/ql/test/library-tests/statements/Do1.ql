/**
 * @name Test for well-formed dos
 */

import csharp

where forall(DoStmt s | exists(s.getCondition()) and exists(s.getBody()))
select 1
