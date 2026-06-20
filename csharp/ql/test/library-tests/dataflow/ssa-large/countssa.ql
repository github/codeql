import csharp

from int uses, int live
where
  uses = strictcount(SsaExplicitWrite ssa, AssignableRead read | read = ssa.getARead()) and
  live = strictcount(SsaExplicitWrite ssa, BasicBlock bb | ssa.isLiveAtEndOfBlock(bb))
select uses, live
