/**
 * @name whilestmt01
 * @description The statement following the while statement in normal is a successor of the condition.
 */

import cpp

from WhileStmt ws, int k, LabelStmt l
where
  ws.getEnclosingFunction().hasName("normal") and
  ws.getParentStmt().hasChild(ws, k) and
  ws.getParentStmt().hasChild(l, k + 1) and
  l = ws.getCondition().getASuccessor() and
  l = ws.getCondition().getAFalseSuccessor() and
  count(ws.getCondition().getAFalseSuccessor()) = 1
select ws.getCondition(), l.getName()
