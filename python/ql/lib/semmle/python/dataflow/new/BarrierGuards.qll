/** Provides commonly used BarrierGuards. */

private import python
private import semmle.python.dataflow.new.DataFlow

private predicate stringConstCompare(DataFlow::GuardNode g, ControlFlowNode node, boolean branch) {
  exists(CompareNode cn | cn = g |
    exists(StrConst str_const, Cmpop op |
      op = any(Eq eq) and branch = true
      or
      op = any(NotEq ne) and branch = false
    |
      cn.operands(str_const.getAFlowNode(), op, node)
      or
      cn.operands(node, op, str_const.getAFlowNode())
    )
    or
    exists(IterableNode str_const_iterable, Cmpop op |
      op = any(In in_) and branch = true
      or
      op = any(NotIn ni) and branch = false
    |
      forall(ControlFlowNode elem | elem = str_const_iterable.getAnElement() |
        elem.getNode() instanceof StrConst
      ) and
      cn.operands(node, op, str_const_iterable)
    )
  )
}

/** A validation of unknown node by comparing with a constant string value. */
class StringConstCompareBarrier extends DataFlow::Node {
  StringConstCompareBarrier() {
    this = DataFlow::BarrierGuard<stringConstCompare/3>::getABarrierNode()
  }
}
