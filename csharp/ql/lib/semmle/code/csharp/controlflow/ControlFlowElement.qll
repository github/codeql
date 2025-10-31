/** Provides the class `ControlFlowElement`. */

import csharp
private import semmle.code.csharp.ExprOrStmtParent
private import semmle.code.csharp.commons.Compilation
private import ControlFlow
private import ControlFlow::BasicBlocks
private import semmle.code.csharp.Caching
private import internal.ControlFlowGraphImpl as Impl

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

  /** Gets the assembly that this element was compiled into. */
  Assembly getAssembly() {
    exists(Compilation c |
      c.getAFileCompiled() = this.getFile() and
      result = c.getOutputAssembly()
    )
  }

  /**
   * Gets a control flow node for this element. That is, a node in the
   * control flow graph that corresponds to this element.
   *
   * Typically, there is exactly one `ControlFlow::Node` associated with a
   * `ControlFlowElement`, but a `ControlFlowElement` may be split into
   * several `ControlFlow::Node`s, for example to represent the continuation
   * flow in a `try/catch/finally` construction.
   */
  Nodes::ElementNode getAControlFlowNode() { result.getAstNode() = this }

  /** Gets the control flow node for this element. */
  ControlFlow::Node getControlFlowNode() { result.getAstNode() = this }

  /** Gets the basic block in which this element occurs. */
  BasicBlock getBasicBlock() { result = this.getAControlFlowNode().getBasicBlock() }

  /**
   * Gets a first control flow node executed within this element.
   */
  Nodes::ElementNode getAControlFlowEntryNode() {
    result = Impl::getAControlFlowEntryNode(this).(ControlFlowElement).getAControlFlowNode()
  }

  /**
   * Gets a potential last control flow node executed within this element.
   */
  Nodes::ElementNode getAControlFlowExitNode() {
    result = Impl::getAControlFlowExitNode(this).(ControlFlowElement).getAControlFlowNode()
  }

  /**
   * Holds if this element is live, that is this element can be reached
   * from the entry point of its enclosing callable.
   */
  predicate isLive() { exists(this.getAControlFlowNode()) }

  /** Holds if the current element is reachable from `src`. */
  // potentially very large predicate, so must be inlined
  pragma[inline]
  predicate reachableFrom(ControlFlowElement src) { this = src.getAReachableElement() }

  /** Gets an element that is reachable from this element. */
  // potentially very large predicate, so must be inlined
  pragma[inline]
  ControlFlowElement getAReachableElement() {
    // Reachable in same basic block
    exists(BasicBlock bb, int i, int j |
      bb.getNode(i) = this.getAControlFlowNode() and
      bb.getNode(j) = result.getAControlFlowNode() and
      i < j
    )
    or
    // Reachable in different basic blocks
    this.getAControlFlowNode().getBasicBlock().getASuccessor+().getANode() =
      result.getAControlFlowNode()
  }

  /**
   * DEPRECATED: Use `Guard` class instead.
   *
   * Holds if basic block `controlled` is controlled by this control flow element
   * with conditional value `s`. That is, `controlled` can only be reached from
   * the callable entry point by going via the `s` edge out of *some* basic block
   * ending with this element.
   *
   * `cb` records all of the possible condition blocks for this control flow element
   * that a path from the callable entry point to `controlled` may go through.
   */
  deprecated predicate controlsBlock(
    BasicBlock controlled, ConditionalSuccessor s, ConditionBlock cb
  ) {
    cb.getLastNode() = this.getAControlFlowNode() and
    cb.edgeDominates(controlled, s)
  }
}
