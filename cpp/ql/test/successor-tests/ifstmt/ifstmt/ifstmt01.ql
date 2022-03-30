/**
 * @name ifstmt01
 * @description In normal, the statement following the if statement is a successor of the condition.
 */

import cpp

from IfStmt is, int k, LabelStmt l2
where
  is.getEnclosingFunction().hasName("normal") and
  is.getParentStmt().hasChild(is, k) and
  is.getParentStmt().hasChild(l2, k + 1) and
  l2 = is.getCondition().getASuccessor() and
  l2 = is.getCondition().getAFalseSuccessor() and
  count(is.getCondition().getAFalseSuccessor()) = 1
select is.getCondition(), l2.getName()
