/**
 * @id cs/examples/empty-block
 * @name Empty blocks
 * @description Finds empty block statements.
 * @tags empty
 *       block
 *       statement
 */

import csharp

from BlockStmt blk
where blk.isEmpty()
select blk
