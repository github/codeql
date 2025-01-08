/**
 * Provides classes and predicates for working with basic blocks in Java.
 */

import java
import Dominance

/**
 * A control-flow node that represents the start of a basic block.
 *
 * A basic block is a series of nodes with no control-flow branching, which can
 * often be treated as a unit in analyses.
 */
class BasicBlock extends ControlFlowNode {
  BasicBlock() {
    not exists(this.getAPredecessor()) and exists(this.getASuccessor())
    or
    strictcount(this.getAPredecessor()) > 1
    or
    exists(ControlFlowNode pred | pred = this.getAPredecessor() |
      strictcount(pred.getASuccessor()) > 1
    )
  }

  /** Gets an immediate successor of this basic block. */
  cached
  BasicBlock getABBSuccessor() { result = this.getLastNode().getASuccessor() }

  /** Gets an immediate predecessor of this basic block. */
  BasicBlock getABBPredecessor() { result.getABBSuccessor() = this }

  /** Gets a control-flow node contained in this basic block. */
  ControlFlowNode getANode() { result = this.getNode(_) }

  /** Gets the control-flow node at a specific (zero-indexed) position in this basic block. */
  cached
  ControlFlowNode getNode(int pos) {
    result = this and pos = 0
    or
    exists(ControlFlowNode mid, int mid_pos | pos = mid_pos + 1 |
      this.getNode(mid_pos) = mid and
      mid.getASuccessor() = result and
      not result instanceof BasicBlock
    )
  }

  /** Gets the first control-flow node in this basic block. */
  ControlFlowNode getFirstNode() { result = this }

  /** Gets the last control-flow node in this basic block. */
  ControlFlowNode getLastNode() { result = this.getNode(this.length() - 1) }

  /** Gets the number of control-flow nodes contained in this basic block. */
  cached
  int length() { result = strictcount(this.getANode()) }

  /** Holds if this basic block strictly dominates `node`. */
  predicate bbStrictlyDominates(BasicBlock node) { bbStrictlyDominates(this, node) }

  /** Holds if this basic block dominates `node`. (This is reflexive.) */
  predicate bbDominates(BasicBlock node) { bbDominates(this, node) }

  /** Holds if this basic block strictly post-dominates `node`. */
  predicate bbStrictlyPostDominates(BasicBlock node) { bbStrictlyPostDominates(this, node) }

  /** Holds if this basic block post-dominates `node`. (This is reflexive.) */
  predicate bbPostDominates(BasicBlock node) { bbPostDominates(this, node) }
}

/** A basic block that ends in an exit node. */
class ExitBlock extends BasicBlock {
  ExitBlock() { this.getLastNode() instanceof ControlFlow::ExitNode }
}
