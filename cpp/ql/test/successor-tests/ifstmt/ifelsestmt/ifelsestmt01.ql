/**
 * @name ifelsestmt01
 * @description In normal, the else branch is a successor of the condition.
 */

import cpp

from IfStmt is
where
  is.getEnclosingFunction().hasName("normal") and
  is.getElse() = is.getCondition().getASuccessor() and
  is.getElse() = is.getCondition().getAFalseSuccessor() and
  count(is.getCondition().getAFalseSuccessor()) = 1
select is.getCondition(), is.getElse().getChild(0).(LabelStmt).getName()
