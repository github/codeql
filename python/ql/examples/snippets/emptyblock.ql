/**
 * @id py/examples/emptyblock
 * @name Empty blocks
 * @description Finds the first statement in a block consisting of nothing but Pass statements
 * @tags empty
 *       block
 *       statement
 */

import python

from StmtList blk
where not exists(Stmt s | not s instanceof Pass)
select blk.getItem(0)
