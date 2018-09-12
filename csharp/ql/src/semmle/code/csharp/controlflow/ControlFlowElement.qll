/** Provides the class `ControlFlowElement`. */

 import csharp
private import semmle.code.csharp.ExprOrStmtParent

/**
 * A program element that can possess control flow. That is, either a statement or
 * an expression.
 *
 * A control flow element can be mapped to a control flow node (`ControlFlow::Node`)
 * via `getAControlFlowNode()`. There is a one-to-many relationship between
 * control flow elements and control flow nodes. This allows control flow
 * splitting, for example modeling the control flow through `finally` blocks.
 */
class ControlFlowElement extends ExprOrStmtParent, @control_flow_element {
  /** Gets the enclosing callable of this element, if any. */
  Callable getEnclosingCallable() { none() }

  /**
   * Gets a control flow node for this element. That is, a node in the
   * control flow graph that corresponds to this element.
   *
   * Typically, there is exactly one `ControlFlow::Node` associated with a
   * `ControlFlowElement`, but a `ControlFlowElement` may be split into
   * several `ControlFlow::Node`s, for example to represent the continuation
   * flow in a `try/catch/finally` construction.
   */
  ControlFlow::Node getAControlFlowNode() {
    result.getElement() = this
  }

  /**
   * Gets a first control flow node executed within this element.
   */
  ControlFlow::Node getAControlFlowEntryNode() {
    result = ControlFlowGraph::Internal::getAControlFlowEntryNode(this).getAControlFlowNode()
  }

  /**
   * Gets a potential last control flow node executed within this element.
   */
  ControlFlow::Node getAControlFlowExitNode() {
    result = ControlFlowGraph::Internal::getAControlFlowExitNode(this).getAControlFlowNode()
  }

  /**
   * Holds if this element is live, that is this element can be reached
   * from the entry point of its enclosing callable.
   */
  predicate isLive() {
    exists(this.getAControlFlowNode())
  }

  /** Holds if the current element is reachable from `src`. */
  predicate reachableFrom(ControlFlowElement src) {
    this = src.getAReachableElement()
  }

  /** Gets an element that is reachable from this element. */
  ControlFlowElement getAReachableElement() {
    // Reachable in same basic block
    exists(ControlFlow::BasicBlock bb, int i, int j |
      bb.getNode(i) = getAControlFlowNode() and
      bb.getNode(j) = result.getAControlFlowNode() and
      i < j
    )
    or
    // Reachable in different basic blocks
    getAControlFlowNode().getBasicBlock().getASuccessor+().getANode() = result.getAControlFlowNode()
  }
}
