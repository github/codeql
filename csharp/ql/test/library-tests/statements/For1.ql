/**
 * @name Test for well-formed fors
 */

import csharp

where forall(ForStmt s | exists(s.getBody()))
select 1
