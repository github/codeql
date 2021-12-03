/**
 * @name ifstmt02
 * @description In normal, the then branch is a successor of the condition.
 */

import cpp

from IfStmt is, BlockStmt t
where
  is.getEnclosingFunction().hasName("normal") and
  t = is.getThen() and
  t = is.getCondition().getASuccessor() and
  t = is.getCondition().getATrueSuccessor() and
  count(is.getCondition().getATrueSuccessor()) = 1
select is.getCondition(), t.getChild(0).(LabelStmt).getName()
