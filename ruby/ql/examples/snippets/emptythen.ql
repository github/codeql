/**
 * @name If statements with empty then branch
 * @description Finds 'if' statements where the 'then' branch is
 *              an empty block statement
 * @id ruby/examples/emptythen
 * @tags if
 *       then
 *       empty
 *       conditional
 *       branch
 *       statement
 */

import ruby

from IfExpr i
where not exists(i.getThen().getAChild())
select i
