/**
 * @id cs/examples/singleton-block
 * @name Singleton blocks
 * @description Finds block statements containing a single statement.
 * @tags block
 *       statement
 */

import csharp

from BlockStmt b
where b.getNumberOfStmts() = 1
select b
