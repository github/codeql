private import DominanceInternal
private import ReachableBlockInternal
private import Dominance
import IR

private class DominancePropertyProvider extends IRPropertyProvider {
  override string getBlockProperty(IRBlock block, string key) {
    exists(IRBlock dominator |
      blockImmediatelyDominates(dominator, block) and
      key = "ImmediateDominator" and
      result = "Block " + dominator.getDisplayIndex().toString()
    )
    or
    key = "DominanceFrontier" and
    result =
      strictconcat(IRBlock frontierBlock |
        frontierBlock = getDominanceFrontier(block)
      |
        frontierBlock.getDisplayIndex().toString(), ", " order by frontierBlock.getDisplayIndex()
      )
  }
}
