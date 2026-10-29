/**
 * @name dostmt05
 * @description The unique successor of each do statement is its body.
 */

import cpp

from DoStmt ds
where
  not (
    ds.getStmt() = ds.getASuccessor() and
    count(ds.getASuccessor()) = 1
  )
select ds
