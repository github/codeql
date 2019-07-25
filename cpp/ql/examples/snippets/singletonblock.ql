/**
 * @id cpp/examples/singletonblock
 * @name Singleton blocks
 * @description Finds block statements containing a single statement
 * @tags block
 *       statement
 */

import cpp

from Block b
where b.getNumStmt() = 1
select b
