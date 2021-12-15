/**
 * @id cpp/examples/returnstatement
 * @name Return statements
 * @description Finds return statements that return `0`
 * @tags return
 *       statement
 *       literal
 */

import cpp

from ReturnStmt r
where r.getExpr().(Literal).getValue().toInt() = 0
select r
