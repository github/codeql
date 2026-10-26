/**
 * @name ifstmt04
 * @description In normal, the label statement following the if statement is the only successor of the last statement in the then block.
 */

import cpp

from IfStmt is, int k, Stmt last, LabelStmt l2
where
  is.getEnclosingFunction().hasName("normal") and
  is.getParentStmt().hasChild(is, k) and
  is.getParentStmt().hasChild(l2, k + 1) and
  last = is.getThen().(BlockStmt).getLastStmt() and
  l2 = last.getASuccessor() and
  count(last.getASuccessor()) = 1
select last, l2.getName()
