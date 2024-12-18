/** Provides commonly used BarrierGuards. */

private import python
private import semmle.python.dataflow.new.DataFlow

private predicate constCompare(DataFlow::GuardNode g, ControlFlowNode node, boolean branch) {
  exists(CompareNode cn | cn = g |
    exists(ImmutableLiteral const, Cmpop op |
      op = any(Eq eq) and branch = true
      or
      op = any(NotEq ne) and branch = false
    |
      cn.operands(const.getAFlowNode(), op, node)
      or
      cn.operands(node, op, const.getAFlowNode())
    )
    or
    exists(NameConstant const, Cmpop op |
      op = any(Is is_) and branch = true
      or
      op = any(IsNot isn) and branch = false
    |
      cn.operands(const.getAFlowNode(), op, node)
      or
      cn.operands(node, op, const.getAFlowNode())
    )
    or
    exists(IterableNode const_iterable, Cmpop op |
      op = any(In in_) and branch = true
      or
      op = any(NotIn ni) and branch = false
    |
      forall(ControlFlowNode elem | elem = const_iterable.getAnElement() |
        elem.getNode() instanceof ImmutableLiteral
      ) and
      cn.operands(node, op, const_iterable)
    )
  )
}

/** A validation of unknown node by comparing with a constant value. */
class ConstCompareBarrier extends DataFlow::Node {
  ConstCompareBarrier() { this = DataFlow::BarrierGuard<constCompare/3>::getABarrierNode() }
}

/** DEPRECATED: Use ConstCompareBarrier instead. */
deprecated class StringConstCompareBarrier = ConstCompareBarrier;
