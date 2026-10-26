/**
 * @name shortforstmt04
 * @description The unique successor of the exit point of the last statement in the body of the for statement in normal is the
 *              for statement's condition or one of its descendants (more precisely, it's the entry point of the condition).
 */

import cpp

from ForStmt fs, ExprStmt last, Expr succ
where
  fs.getEnclosingFunction().hasName("normal") and
  last = fs.getStmt().(BlockStmt).getLastStmt() and
  succ = fs.getCondition().getAChild*() and
  succ = last.getExpr().getASuccessor() and
  count(last.getExpr().getASuccessor()) = 1
select fs, last.getExpr(), succ
