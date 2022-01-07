/** Provides commonly used BarrierGuards. */

private import python
private import semmle.python.dataflow.new.DataFlow

/** A validation of unknown node by comparing with a constant string value. */
class StringConstCompare extends DataFlow::BarrierGuard, CompareNode {
  ControlFlowNode checked_node;
  boolean safe_branch;

  StringConstCompare() {
    exists(StrConst str_const, Cmpop op |
      op = any(Eq eq) and safe_branch = true
      or
      op = any(NotEq ne) and safe_branch = false
    |
      this.operands(str_const.getAFlowNode(), op, checked_node)
      or
      this.operands(checked_node, op, str_const.getAFlowNode())
    )
    or
    exists(IterableNode str_const_iterable, Cmpop op |
      op = any(In in_) and safe_branch = true
      or
      op = any(NotIn ni) and safe_branch = false
    |
      forall(ControlFlowNode elem | elem = str_const_iterable.getAnElement() |
        elem.getNode() instanceof StrConst
      ) and
      this.operands(checked_node, op, str_const_iterable)
    )
  }

  override predicate checks(ControlFlowNode node, boolean branch) {
    node = checked_node and branch = safe_branch
  }
}
