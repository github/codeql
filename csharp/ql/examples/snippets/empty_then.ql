/**
 * @id cs/examples/empty-then
 * @name If statements with empty then branch
 * @description Finds 'if' statements where the 'then' branch is
 *              an empty block statement.
 * @tags if
 *       then
 *       empty
 *       conditional
 *       branch
 */

import csharp

from IfStmt i
where i.getThen().(BlockStmt).isEmpty()
select i
