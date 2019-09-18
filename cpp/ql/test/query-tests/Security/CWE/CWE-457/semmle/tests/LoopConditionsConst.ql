import cpp
import LoopConditionsConst

from Loop l, Expr condition
where l.getCondition() = condition
select l, condition, concat(int val | loopEntryConst(condition, val) | val.toString(), ", "),
  concat(BasicBlock bb | bb.getASuccessor() = l.getStmt() | bb.toString(), ", "),
  concat(l.getStmt().toString(), ", "),
  concat(BasicBlock bb | bb.getASuccessor() = l.getFollowingStmt() | bb.toString(), ", "),
  concat(l.getFollowingStmt().toString(), ", ")
