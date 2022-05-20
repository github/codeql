/**
 * @name shortforstmt05
 * @description The unique successor of a for statement is its condition or one of its condition's descendants.
 */

import cpp

from ForStmt fs
where
  not (
    fs.getASuccessor() = fs.getCondition().getAChild*() and
    count(fs.getASuccessor()) = 1
  )
select fs
