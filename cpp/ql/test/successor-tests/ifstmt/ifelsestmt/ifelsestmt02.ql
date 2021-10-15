/**
 * @name ifelsestmt02
 * @description In normal, the then branch is a successor of the condition.
 */

import cpp

from IfStmt is
where
  is.getEnclosingFunction().hasName("normal") and
  is.getThen() = is.getCondition().getASuccessor() and
  is.getThen() = is.getCondition().getATrueSuccessor() and
  count(is.getCondition().getATrueSuccessor()) = 1
select is.getCondition(), is.getThen().getChild(0).(LabelStmt).getName()
