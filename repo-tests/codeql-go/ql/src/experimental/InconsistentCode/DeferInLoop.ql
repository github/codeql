/**
 * @name Defer in loop
 * @description A deferred statement in a loop will not execute until the end of the function.
 *              This can lead to unintentionally holding resources open like file handles or database transactions.
 * @id go/examples/deferinloop
 * @kind problem
 * @tags defer
 *       nesting
 */

import go

from LoopStmt loop, DeferStmt defer
where loop.getBody().getAChildStmt+() = defer
select defer, "This defer statement is in a $@.", loop, "loop"
