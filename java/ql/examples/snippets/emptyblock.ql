/**
 * @id java/examples/emptyblock
 * @name Empty blocks
 * @description Finds empty block statements
 * @tags empty
 *       block
 *       statement
 */

import java

from BlockStmt blk
where blk.getNumStmt() = 0
select blk
