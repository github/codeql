/**
 * @name dostmt02
 * @description The body of the do statement in normal is a successor of the condition.
 */

import cpp

from DoStmt ds
where
  ds.getEnclosingFunction().hasName("normal") and
  ds.getStmt() = ds.getCondition().getASuccessor() and
  ds.getStmt() = ds.getCondition().getATrueSuccessor() and
  count(ds.getCondition().getATrueSuccessor()) = 1
select ds.getCondition(), ds.getStmt()
