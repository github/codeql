/**
 * @name Increment statements in loops
 * @description Finds increment statements that are nested in a loop
 * @id go/examples/updateinloop
 * @tags nesting
 *       increment
 */

import go

from IncStmt s, LoopStmt l
where s.getParent+() = l
select s, l
