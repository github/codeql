/**
 * @name 'break' or 'return' statement in finally
 * @description Using a Break or Return statement in a finally block causes the
 *              Try-finally block to exit, discarding the exception.
 * @kind problem
 * @tags reliability
 *       maintainability
 *       external/cwe/cwe-584
 * @problem.severity warning
 * @sub-severity low
 * @precision medium
 * @id py/exit-from-finally
 */

import python

from Stmt s, string kind
where
  s instanceof Return and kind = "return" and exists(Try t | t.getFinalbody().contains(s))
  or
  s instanceof Break and
  kind = "break" and
  exists(Try t | t.getFinalbody().contains(s) |
    not exists(For loop | loop.contains(s) and t.getFinalbody().contains(loop)) and
    not exists(While loop | loop.contains(s) and t.getFinalbody().contains(loop))
  )
select s, "'" + kind + "' in a finally block will swallow any exceptions raised."
