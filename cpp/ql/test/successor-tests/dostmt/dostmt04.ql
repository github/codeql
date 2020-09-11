/**
 * @name dostmt04
 * @description In normal, the do condition or one of the condition's descendants is the unique successor of the exit point of the last statement in the body.
 */

import cpp

from DoStmt ds, ExprStmt last, Expr succ
where
  ds.getEnclosingFunction().hasName("normal") and
  last = ds.getStmt().(BlockStmt).getLastStmt() and
  succ = last.getExpr().getASuccessor() and
  succ = ds.getCondition().getAChild*() and
  count(last.getExpr().getASuccessor()) = 1
select last.getExpr(), succ
