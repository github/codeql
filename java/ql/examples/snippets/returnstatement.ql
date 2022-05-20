/**
 * @id java/examples/returnstatement
 * @name Return statements
 * @description Finds return statements that return 'null'
 * @tags return
 *       statement
 *       null
 */

import java

from ReturnStmt r
where r.getResult() instanceof NullLiteral
select r
