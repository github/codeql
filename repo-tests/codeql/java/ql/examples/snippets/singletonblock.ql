/**
 * @id java/examples/singletonblock
 * @name Singleton blocks
 * @description Finds block statements containing a single statement
 * @tags block
 *       statement
 */

import java

from BlockStmt b
where b.getNumStmt() = 1
select b
