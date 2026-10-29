import javascript

from ReachableBasicBlock callBlock, ReachableBasicBlock entryBlock, CallExpr c, Function f
where
  callBlock.postDominates(entryBlock) and
  callBlock.getANode() = c and
  entryBlock.getANode() = f.getEntry()
select c
