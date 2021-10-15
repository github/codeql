/**
 * @name whilestmt04
 * @description In normal, the while condition or one of the condition's descendants is the unique successor of the exit point of the last statement in the body.
 */

import cpp

from WhileStmt ws, ExprStmt last, Expr succ
where
  ws.getEnclosingFunction().hasName("normal") and
  last = ws.getStmt().(BlockStmt).getLastStmt() and
  succ = last.getExpr().getASuccessor() and
  succ = ws.getCondition().getAChild*() and
  count(last.getExpr().getASuccessor()) = 1
select last.getExpr(), succ
