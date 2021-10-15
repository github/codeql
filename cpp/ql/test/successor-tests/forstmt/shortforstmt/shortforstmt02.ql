/**
 * @name shortforstmt02
 * @description The body of the for statement in normal is a successor of the condition.
 */

import cpp

from ForStmt fs
where
  fs.getEnclosingFunction().hasName("normal") and
  fs.getStmt() = fs.getCondition().getASuccessor() and
  fs.getStmt() = fs.getCondition().getATrueSuccessor() and
  count(fs.getCondition().getATrueSuccessor()) = 1
select fs.getCondition(), fs.getStmt()
