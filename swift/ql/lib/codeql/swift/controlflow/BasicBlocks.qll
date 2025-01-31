/** Provides classes representing basic blocks. */

private import ControlFlowGraph
private import internal.ControlFlowGraphImpl as CfgImpl
private import SuccessorTypes
private import CfgImpl::BasicBlocks as BasicBlocksImpl

/**
 * A basic block, that is, a maximal straight-line sequence of control flow nodes
 * without branches or joins.
 */
final class BasicBlock extends BasicBlocksImpl::BasicBlock {
  /** Gets an immediate successor of this basic block, if any. */
  BasicBlock getASuccessor() { result = super.getASuccessor() }

  /** Gets an immediate successor of this basic block of a given type, if any. */
  BasicBlock getASuccessor(SuccessorType t) { result = super.getASuccessor(t) }

  /** Gets an immediate predecessor of this basic block, if any. */
  BasicBlock getAPredecessor() { result = super.getAPredecessor() }

  /** Gets an immediate predecessor of this basic block of a given type, if any. */
  BasicBlock getAPredecessor(SuccessorType t) { result = super.getAPredecessor(t) }

  /** Gets the control flow node at a specific (zero-indexed) position in this basic block. */
  ControlFlowNode getNode(int pos) { result = super.getNode(pos) }

  /** Gets a control flow node in this basic block. */
  ControlFlowNode getANode() { result = super.getANode() }

  /** Gets the first control flow node in this basic block. */
  ControlFlowNode getFirstNode() { result = super.getFirstNode() }

  /** Gets the last control flow node in this basic block. */
  ControlFlowNode getLastNode() { result = super.getLastNode() }

  predicate immediatelyDominates(BasicBlock bb) { super.immediatelyDominates(bb) }

  predicate strictlyDominates(BasicBlock bb) { super.strictlyDominates(bb) }

  predicate dominates(BasicBlock bb) { super.dominates(bb) }

  predicate inDominanceFrontier(BasicBlock df) { super.inDominanceFrontier(df) }

  BasicBlock getImmediateDominator() { result = super.getImmediateDominator() }

  predicate strictlyPostDominates(BasicBlock bb) { super.strictlyPostDominates(bb) }

  predicate postDominates(BasicBlock bb) { super.postDominates(bb) }
}

/**
 * An entry basic block, that is, a basic block whose first node is
 * an entry node.
 */
final class EntryBasicBlock extends BasicBlock, BasicBlocksImpl::EntryBasicBlock { }

/**
 * An annotated exit basic block, that is, a basic block that contains an
 * annotated exit node.
 */
final class AnnotatedExitBasicBlock extends BasicBlock, BasicBlocksImpl::AnnotatedExitBasicBlock { }

/**
 * An exit basic block, that is, a basic block whose last node is
 * an exit node.
 */
final class ExitBasicBlock extends BasicBlock, BasicBlocksImpl::ExitBasicBlock { }

/** A basic block with more than one predecessor. */
final class JoinBlock extends BasicBlock, BasicBlocksImpl::JoinBasicBlock {
  JoinBlock() { this.getFirstNode().isJoin() }

  /**
   * Gets the `i`th predecessor of this join block, with respect to some
   * arbitrary order.
   */
  JoinBlockPredecessor getJoinBlockPredecessor(int i) { result = super.getJoinBlockPredecessor(i) }
}

/** A basic block that is an immediate predecessor of a join block. */
class JoinBlockPredecessor extends BasicBlock, BasicBlocksImpl::JoinPredecessorBasicBlock { }

/** A basic block that terminates in a condition, splitting the subsequent control flow. */
final class ConditionBlock extends BasicBlock, BasicBlocksImpl::ConditionBasicBlock {
  /**
   * Holds if basic block `succ` is immediately controlled by this basic
   * block with conditional value `s`. That is, `succ` is an immediate
   * successor of this block, and `succ` can only be reached from
   * the callable entry point by going via the `s` edge out of this basic block.
   */
  predicate immediatelyControls(BasicBlock succ, ConditionalSuccessor s) {
    super.immediatelyControls(succ, s)
  }

  /**
   * Holds if basic block `controlled` is controlled by this basic block with
   * conditional value `s`. That is, `controlled` can only be reached from
   * the callable entry point by going via the `s` edge out of this basic block.
   */
  predicate controls(BasicBlock controlled, ConditionalSuccessor s) {
    super.controls(controlled, s)
  }
}
