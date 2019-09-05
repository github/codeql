/**
 * @name whilestmt02
 * @description The body of the while statement in normal is a successor of the condition.
 */

import cpp

from WhileStmt ws
where
  ws.getEnclosingFunction().hasName("normal") and
  ws.getStmt() = ws.getCondition().getASuccessor() and
  ws.getStmt() = ws.getCondition().getATrueSuccessor() and
  count(ws.getCondition().getATrueSuccessor()) = 1
select ws.getCondition(), ws.getStmt()
