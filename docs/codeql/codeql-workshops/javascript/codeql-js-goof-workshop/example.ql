/**
 * @name Empty block
 * @kind problem
 * @problem.severity warning
 * @id javascript/example/empty-block
 */

import javascript
 
from Block b
where b.getNumStmt() = 0
select b, "This is an empty block."