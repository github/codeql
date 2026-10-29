/**
 * @name shortforstmt01
 * @description The statement following the for statement in normal is a successor of the condition.
 */

import cpp

from ForStmt fs, int k, LabelStmt l
where
  fs.getEnclosingFunction().hasName("normal") and
  fs.getParentStmt().hasChild(fs, k) and
  fs.getParentStmt().hasChild(l, k + 1) and
  l = fs.getCondition().getASuccessor() and
  l = fs.getCondition().getAFalseSuccessor() and
  count(fs.getCondition().getAFalseSuccessor()) = 1
select fs.getCondition(), l.getName()
