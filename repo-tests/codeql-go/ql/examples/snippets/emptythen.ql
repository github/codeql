/**
 * @name If statements with empty then branch
 * @description Finds 'if' statements where the 'then' branch is
 *              an empty block statement
 * @id go/examples/emptythen
 * @tags if
 *       then
 *       empty
 *       conditional
 *       branch
 *       statement
 */

import go

from IfStmt i
where i.getThen().getNumStmt() = 0
select i
