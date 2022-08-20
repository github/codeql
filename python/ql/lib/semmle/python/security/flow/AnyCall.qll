import python
import semmle.python.security.strings.Basic

/** Assume that taint flows from argument to result for *any* call */
deprecated class AnyCallStringFlow extends DataFlowExtension::DataFlowNode {
  AnyCallStringFlow() { any(CallNode call).getAnArg() = this }

  override ControlFlowNode getASuccessorNode() { result.(CallNode).getAnArg() = this }
}
