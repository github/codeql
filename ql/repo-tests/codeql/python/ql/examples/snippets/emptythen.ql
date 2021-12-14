/**
 * @id py/examples/emptythen
 * @name If statements with empty then branch
 * @description Finds 'if' statements where the "then" branch
 *              consists entirely of Pass statements
 * @tags if
 *       then
 *       empty
 *       conditional
 *       branch
 */

import python

from If i
where
  not exists(Stmt s |
    i.getStmt(_) = s and
    not s instanceof Pass
  )
select i
