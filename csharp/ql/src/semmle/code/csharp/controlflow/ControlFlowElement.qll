/** Provides the class `ControlFlowElement`. */

import csharp
private import semmle.code.csharp.ExprOrStmtParent
private import ControlFlow
private import ControlFlow::BasicBlocks
private import SuccessorTypes
private import semmle.code.csharp.Caching

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
  Assembly getAssembly() { result = this.getEnclosingCallable().getDeclaringType().getALocation() }

  /**
   * Gets a control flow node for this element. That is, a node in the
   * control flow graph that corresponds to this element.
   *
   * Typically, there is exactly one `ControlFlow::Node` associated with a
   * `ControlFlowElement`, but a `ControlFlowElement` may be split into
   * several `ControlFlow::Node`s, for example to represent the continuation
   * flow in a `try/catch/finally` construction.
   */
  Nodes::ElementNode getAControlFlowNode() { result.getElement() = this }

  /**
   * Gets a first control flow node executed within this element.
   */
  Nodes::ElementNode getAControlFlowEntryNode() {
    result = Internal::getAControlFlowEntryNode(this).getAControlFlowNode()
  }

  /**
   * Gets a potential last control flow node executed within this element.
   */
  Nodes::ElementNode getAControlFlowExitNode() {
    result = Internal::getAControlFlowExitNode(this).getAControlFlowNode()
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
      bb.getNode(i) = getAControlFlowNode() and
      bb.getNode(j) = result.getAControlFlowNode() and
      i < j
    )
    or
    // Reachable in different basic blocks
    getAControlFlowNode().getBasicBlock().getASuccessor+().getANode() = result.getAControlFlowNode()
  }

  pragma[noinline]
  private predicate immediatelyControlsBlockSplit0(
    ConditionBlock cb, BasicBlock succ, ConditionalSuccessor s
  ) {
    // Only calculate dominance by explicit recursion for split nodes;
    // all other nodes can use regular CFG dominance
    this instanceof ControlFlow::Internal::SplitControlFlowElement and
    cb.getLastNode() = this.getAControlFlowNode() and
    succ = cb.getASuccessorByType(s)
  }

  pragma[noinline]
  private predicate immediatelyControlsBlockSplit1(
    ConditionBlock cb, BasicBlock succ, ConditionalSuccessor s, BasicBlock pred, SuccessorType t
  ) {
    this.immediatelyControlsBlockSplit0(cb, succ, s) and
    pred = succ.getAPredecessorByType(t) and
    pred != cb
  }

  pragma[noinline]
  private predicate immediatelyControlsBlockSplit2(
    ConditionBlock cb, BasicBlock succ, ConditionalSuccessor s, BasicBlock pred, SuccessorType t
  ) {
    this.immediatelyControlsBlockSplit1(cb, succ, s, pred, t) and
    (
      succ.dominates(pred)
      or
      // `pred` might be another split of this element
      pred.getLastNode().getElement() = this and
      t = s
    )
  }

  /**
   * Holds if basic block `succ` is immediately controlled by this control flow
   * element with conditional value `s`. That is, `succ` can only be reached from
   * the callable entry point by going via the `s` edge out of *some* basic block
   * `pred` ending with this element, and `pred` is an immediate predecessor
   * of `succ`.
   *
   * Moreover, this control flow element corresponds to multiple control flow nodes,
   * which is why
   *
   * ```ql
   * exists(ConditionBlock cb |
   *   cb.getLastNode() = this.getAControlFlowNode() |
   *   cb.immediatelyControls(succ, s)
   * )
   * ```
   *
   * does not work.
   *
   * `cb` records all of the possible condition blocks for this control flow element
   * that a path from the callable entry point to `succ` may go through.
   */
  pragma[nomagic]
  private predicate immediatelyControlsBlockSplit(
    BasicBlock succ, ConditionalSuccessor s, ConditionBlock cb
  ) {
    this.immediatelyControlsBlockSplit0(cb, succ, s) and
    forall(BasicBlock pred, SuccessorType t |
      this.immediatelyControlsBlockSplit1(cb, succ, s, pred, t)
    |
      this.immediatelyControlsBlockSplit2(cb, succ, s, pred, t)
    )
  }

  pragma[noinline]
  private predicate controlsJoinBlockPredecessor(
    JoinBlock controlled, ConditionalSuccessor s, int i, ConditionBlock cb
  ) {
    this.controlsBlockSplit(controlled.getJoinBlockPredecessor(i), s, cb)
  }

  private predicate controlsJoinBlockSplit(JoinBlock controlled, ConditionalSuccessor s, int i) {
    i = -1 and
    this.controlsJoinBlockPredecessor(controlled, s, _, _)
    or
    this.controlsJoinBlockSplit(controlled, s, i - 1) and
    (
      this.controlsJoinBlockPredecessor(controlled, s, i, _)
      or
      controlled.dominates(controlled.getJoinBlockPredecessor(i))
    )
  }

  cached
  private predicate controlsBlockSplit(
    BasicBlock controlled, ConditionalSuccessor s, ConditionBlock cb
  ) {
    Stages::GuardsStage::forceCachingInSameStage() and
    this.immediatelyControlsBlockSplit(controlled, s, cb)
    or
    // Equivalent with
    //
    // ```ql
    // exists(JoinBlockPredecessor pred | pred = controlled.getAPredecessor() |
    //   this.controlsBlockSplit(pred, s)
    // ) and
    // forall(JoinBlockPredecessor pred | pred = controlled.getAPredecessor() |
    //   this.controlsBlockSplit(pred, s)
    //   or
    //   controlled.dominates(pred)
    // )
    // ```
    //
    // but uses no universal recursion for better performance.
    exists(int last |
      last = max(int i | exists(controlled.(JoinBlock).getJoinBlockPredecessor(i)))
    |
      this.controlsJoinBlockSplit(controlled, s, last)
    ) and
    this.controlsJoinBlockPredecessor(controlled, s, _, cb)
    or
    not controlled instanceof JoinBlock and
    this.controlsBlockSplit(controlled.getAPredecessor(), s, cb)
  }

  /**
   * Holds if basic block `controlled` is controlled by this control flow element
   * with conditional value `s`. That is, `controlled` can only be reached from
   * the callable entry point by going via the `s` edge out of *some* basic block
   * ending with this element.
   *
   * This predicate is different from
   *
   * ```ql
   * exists(ConditionBlock cb |
   *   cb.getLastNode() = this.getAControlFlowNode() |
   *   cb.controls(controlled, s)
   * )
   * ```
   *
   * as control flow splitting is taken into account.
   *
   * `cb` records all of the possible condition blocks for this control flow element
   * that a path from the callable entry point to `controlled` may go through.
   */
  predicate controlsBlock(BasicBlock controlled, ConditionalSuccessor s, ConditionBlock cb) {
    this.controlsBlockSplit(controlled, s, cb)
    or
    cb.getLastNode() = this.getAControlFlowNode() and
    cb.controls(controlled, s)
  }

  /** DEPRECATED: Use `controlsBlock/3` instead. */
  deprecated predicate controlsBlock(BasicBlock controlled, ConditionalSuccessor s) {
    this.controlsBlock(controlled, s, _)
  }

  /**
   * DEPRECATED.
   *
   * Holds if control flow element `controlled` is controlled by this control flow
   * element with conditional value `s`. That is, `controlled` can only be reached
   * from the callable entry point by going via the `s` edge out of this element.
   *
   * This predicate is different from
   *
   * ```ql
   * exists(ConditionBlock cb |
   *   cb.getLastNode() = this.getAControlFlowNode() |
   *   cb.controls(controlled.getAControlFlowNode().getBasicBlock(), s)
   * )
   * ```
   *
   * as control flow splitting is taken into account.
   */
  // potentially very large predicate, so must be inlined
  pragma[inline]
  deprecated predicate controlsElement(ControlFlowElement controlled, ConditionalSuccessor s) {
    forex(BasicBlock bb | bb = controlled.getAControlFlowNode().getBasicBlock() |
      this.controlsBlock(bb, s)
    )
  }
}
