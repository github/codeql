private import ReachableBlockInternal
private import ReachableBlock
import IR

private class ReachableBlockPropertyProvider extends IRPropertyProvider {
  override string getBlockProperty(IRBlock block, string key) {
    not block instanceof ReachableBlock and
    key = "Unreachable" and
    result = "true"
    or
    exists(EdgeKind kind |
      isInfeasibleEdge(block, kind) and
      key = "Infeasible(" + kind.toString() + ")" and
      result = "true"
    )
  }
}
