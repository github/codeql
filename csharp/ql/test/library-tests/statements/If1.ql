/**
 * @name Test for well-formed ifs
 */

import csharp

where forall(IfStmt m | exists(m.getCondition()) and exists(m.getThen()))
select 1
