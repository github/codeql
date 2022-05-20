/**
 * @name dostmt01
 * @description The statement following the do statement in normal is a successor of the condition.
 */

import cpp

from DoStmt ds, int k, LabelStmt l
where
  ds.getEnclosingFunction().hasName("normal") and
  ds.getParentStmt().hasChild(ds, k) and
  ds.getParentStmt().hasChild(l, k + 1) and
  l = ds.getCondition().getASuccessor() and
  l = ds.getCondition().getAFalseSuccessor() and
  count(ds.getCondition().getAFalseSuccessor()) = 1
select ds.getCondition(), l.getName()
