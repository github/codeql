import csharp

from int uses, int live
where
  uses = strictcount(Ssa::ExplicitDefinition ssa, AssignableRead read | read = ssa.getARead()) and
  live = strictcount(Ssa::ExplicitDefinition ssa, BasicBlock bb | ssa.isLiveAtEndOfBlock(bb))
select uses, live
