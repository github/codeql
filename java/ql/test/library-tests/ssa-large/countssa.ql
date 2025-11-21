import java
import semmle.code.java.dataflow.SSA

from int uses, int live
where
  uses = strictcount(SsaDefinition ssa, VarRead use | use = ssa.getARead()) and
  live = strictcount(SsaDefinition ssa, BasicBlock b | ssa.isLiveAtEndOfBlock(b))
select uses, live
