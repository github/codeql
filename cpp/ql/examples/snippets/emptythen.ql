/**
 * @id cpp/examples/emptythen
 * @name If statements with empty then branch
 * @description Finds `if` statements where the `then` branch is
 *              an empty block statement
 * @tags if
 *       then
 *       empty
 *       conditional
 *       branch
 */

import cpp

from IfStmt i
where i.getThen().(BlockStmt).getNumStmt() = 0
select i
