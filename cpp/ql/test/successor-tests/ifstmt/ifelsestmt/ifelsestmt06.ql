/**
 * @name ifelsestmt06
 * @description In normal, the statement following the if statement is the only successor of the last statement in the else block.
 */

import cpp

from IfStmt is, int k, Stmt last, LabelStmt l3
where
  is.getEnclosingFunction().hasName("normal") and
  is.getParentStmt().hasChild(is, k) and
  is.getParentStmt().hasChild(l3, k + 1) and
  last = is.getElse().(BlockStmt).getLastStmt() and
  l3 = last.getASuccessor() and
  count(last.getASuccessor()) = 1
select last, l3.getName()
