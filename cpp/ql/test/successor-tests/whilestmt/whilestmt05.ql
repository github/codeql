/**
 * @name whilestmt05
 * @description The unique successor each while statement is its condition or one of the condition's descendants.
 */

import cpp

from WhileStmt ws
where
  not (
    ws.getCondition().getAChild*() = ws.getASuccessor() and
    count(ws.getASuccessor()) = 1
  )
select ws
