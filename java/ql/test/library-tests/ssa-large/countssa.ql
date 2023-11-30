import java
import semmle.code.java.dataflow.SSA

from int uses, int live
where
  uses = strictcount(SsaVariable ssa, VarRead use | use = ssa.getAUse()) and
  live = strictcount(SsaVariable ssa, BasicBlock b | ssa.isLiveAtEndOfBlock(b))
select uses, live
