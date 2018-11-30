/** Provides the class `ControlFlowElement`. */

import csharp
private import semmle.code.csharp.ExprOrStmtParent
private import ControlFlow
private import ControlFlow::BasicBlocks
private import SuccessorTypes

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
  Node getAControlFlowNode() {
    result.getElement() = this
  }

  /**
   * Gets a first control flow node executed within this element.
   */
  Node getAControlFlowEntryNode() {
    result = ControlFlowGraph::Internal::getAControlFlowEntryNode(this).getAControlFlowNode()
  }

  /**
   * Gets a potential last control flow node executed within this element.
   */
  Node getAControlFlowExitNode() {
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
    exists(BasicBlock bb, int i, int j |
      bb.getNode(i) = getAControlFlowNode() and
      bb.getNode(j) = result.getAControlFlowNode() and
      i < j
    )
    or
    // Reachable in different basic blocks
    getAControlFlowNode().getBasicBlock().getASuccessor+().getANode() = result.getAControlFlowNode()
  }

  /**
   * Holds if basic block `succ` is immediately controlled by this control flow
   * element with conditional value `s`. That is, `succ` can only be reached from
   * the callable entry point by going via the `s` edge out of *some* basic block
   * `pred` ending with this element, and `pred` is an immediate predecessor
   * of `succ`.
   *
   * This predicate is different from
   * `this.getAControlFlowNode().getBasicBlock().(ConditionBlock).immediatelyControls(succ, s)`
   * in that it takes control flow splitting into account.
   */
  pragma[nomagic]
  private predicate immediatelyControls(BasicBlock succ, ConditionalSuccessor s) {
    exists(ConditionBlock cb |
      cb.getLastNode() = this.getAControlFlowNode() |
      succ = cb.getASuccessorByType(s) and
      forall(BasicBlock pred, SuccessorType  t |
        pred = succ.getAPredecessorByType(t) and pred != cb |
        succ.dominates(pred)
        or
        // `pred` might be another split of `cfe`
        pred.getLastNode().getElement() = this and
        pred.getASuccessorByType(t) = succ and
        t = s
      )
    )
  }

  pragma[nomagic]
  private JoinBlockPredecessor getAPossiblyControlledPredecessor(JoinBlock controlled, ConditionalSuccessor s) {
    exists(BasicBlock mid |
      this.immediatelyControls(mid, s) |
      result = mid.getASuccessor*()
    ) and
    result.getASuccessor() = controlled
  }

  pragma[nomagic]
  private predicate isPossiblyControlledJoinBlock(JoinBlock controlled, ConditionalSuccessor s) {
    exists(this.getAPossiblyControlledPredecessor(controlled, s)) and
    forall(BasicBlock pred |
      pred = controlled.getAPredecessor() |
      pred = this.getAPossiblyControlledPredecessor(controlled, s)
    )
  }

  /**
   * Holds if basic block `controlled` is controlled by this control flow element
   * with conditional value `s`. That is, `controlled` can only be reached from
   * the callable entry point by going via the `s` edge out of *some* basic block
   * ending with this element.
   *
   * This predicate is different from
   * `this.getAControlFlowNode().getBasicBlock().(ConditionBlock).controls(controlled, s)`
   * in that it takes control flow splitting into account.
   */
  cached
  predicate controlsBlock(BasicBlock controlled, ConditionalSuccessor s) {
    this.immediatelyControls(controlled, s)
    or
    if controlled instanceof JoinBlock then
      this.isPossiblyControlledJoinBlock(controlled, s) and
      forall(BasicBlock pred |
        pred = this.getAPossiblyControlledPredecessor(controlled, s) |
        this.controlsBlock(pred, s)
      )
    else
      this.controlsBlock(controlled.getAPredecessor(), s)
  }

  /**
   * Holds if control flow element `controlled` is controlled by this control flow
   * element with conditional value `s`. That is, `controlled` can only be reached
   * from the callable entry point by going via the `s` edge out of this element.
   *
   * This predicate is different from
   * `this.getAControlFlowNode().getBasicBlock().(ConditionBlock).controls(controlled.getAControlFlowNode().getBasicBlock(), s)`
   * in that it takes control flow splitting into account.
   */
  pragma[inline] // potentially very large predicate, so must be inlined
  predicate controlsElement(ControlFlowElement controlled, ConditionalSuccessor s) {
    forex(BasicBlock bb |
      bb = controlled.getAControlFlowNode().getBasicBlock() |
      this.controlsBlock(bb, s)
    )
  }
}
