/** Provides the class `ControlFlowElement`. */

import csharp
private import semmle.code.csharp.ExprOrStmtParent
private import semmle.code.csharp.commons.Compilation
private import ControlFlow
private import semmle.code.csharp.Caching

private class TControlFlowElementOrCallable = @callable or @control_flow_element;

class ControlFlowElementOrCallable extends ExprOrStmtParent, TControlFlowElementOrCallable { }

/**
 * A program element that can possess control flow. That is, either a statement or
 * an expression.
 *
 * A control flow element can be mapped to a control flow node (`ControlFlowNode`)
 * via `getAControlFlowNode()`. There is a one-to-many relationship between
 * control flow elements and control flow nodes. This allows control flow
 * splitting, for example modeling the control flow through `finally` blocks.
 */
class ControlFlowElement extends ControlFlowElementOrCallable, @control_flow_element {
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
   */
  ControlFlowNodes::ElementNode getAControlFlowNode() { result = this.getControlFlowNode() }

  /** Gets the control flow node for this element. */
  ControlFlowNode getControlFlowNode() { result.injects(this) }

  /** Gets the basic block in which this element occurs. */
  BasicBlock getBasicBlock() { result = this.getAControlFlowNode().getBasicBlock() }

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
}
