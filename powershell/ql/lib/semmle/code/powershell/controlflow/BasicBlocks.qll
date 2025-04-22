/** Provides classes representing basic blocks. */

private import powershell
private import ControlFlowGraph
private import CfgNodes
private import SuccessorTypes
private import internal.ControlFlowGraphImpl as CfgImpl
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

  // The overrides below are to use `CfgNode` instead of `CfgImpl::Node`
  CfgNode getNode(int pos) { result = super.getNode(pos) }

  CfgNode getANode() { result = super.getANode() }

  /** Gets the first control flow node in this basic block. */
  CfgNode getFirstNode() { result = super.getFirstNode() }

  /** Gets the last control flow node in this basic block. */
  CfgNode getLastNode() { result = super.getLastNode() }

  /**
   * Holds if this basic block immediately dominates basic block `bb`.
   *
   * That is, this basic block is the unique basic block satisfying:
   * 1. This basic block strictly dominates `bb`
   * 2. There exists no other basic block that is strictly dominated by this
   *    basic block and which strictly dominates `bb`.
   *
   * All basic blocks, except entry basic blocks, have a unique immediate
   * dominator.
   */
  predicate immediatelyDominates(BasicBlock bb) { super.immediatelyDominates(bb) }

  /**
   * Holds if this basic block strictly dominates basic block `bb`.
   *
   * That is, all paths reaching basic block `bb` from some entry point
   * basic block must go through this basic block (which must be different
   * from `bb`).
   */
  predicate strictlyDominates(BasicBlock bb) { super.strictlyDominates(bb) }

  /**
   * Holds if this basic block dominates basic block `bb`.
   *
   * That is, all paths reaching basic block `bb` from some entry point
   * basic block must go through this basic block.
   */
  predicate dominates(BasicBlock bb) { super.dominates(bb) }

  /**
   * Holds if `df` is in the dominance frontier of this basic block.
   * That is, this basic block dominates a predecessor of `df`, but
   * does not dominate `df` itself.
   */
  predicate inDominanceFrontier(BasicBlock df) { super.inDominanceFrontier(df) }

  /**
   * Gets the basic block that immediately dominates this basic block, if any.
   *
   * That is, the result is the unique basic block satisfying:
   * 1. The result strictly dominates this basic block.
   * 2. There exists no other basic block that is strictly dominated by the
   *    result and which strictly dominates this basic block.
   *
   * All basic blocks, except entry basic blocks, have a unique immediate
   * dominator.
   */
  BasicBlock getImmediateDominator() { result = super.getImmediateDominator() }

  /**
   * Holds if the edge with successor type `s` out of this basic block is a
   * dominating edge for `dominated`.
   *
   * That is, all paths reaching `dominated` from the entry point basic
   * block must go through the `s` edge out of this basic block.
   *
   * Edge dominance is similar to node dominance except it concerns edges
   * instead of nodes: A basic block is dominated by a _basic block_ `bb` if it
   * can only be reached through `bb` and dominated by an _edge_ `s` if it can
   * only be reached through `s`.
   *
   * Note that where all basic blocks (except the entry basic block) are
   * strictly dominated by at least one basic block, a basic block may not be
   * dominated by any edge. If an edge dominates a basic block `bb`, then
   * both endpoints of the edge dominates `bb`. The converse is not the case,
   * as there may be multiple paths between the endpoints with none of them
   * dominating.
   */
  predicate edgeDominates(BasicBlock dominated, SuccessorType s) {
    super.edgeDominates(dominated, s)
  }

  /**
   * Holds if this basic block strictly post-dominates basic block `bb`.
   *
   * That is, all paths reaching a normal exit point basic block from basic
   * block `bb` must go through this basic block (which must be different
   * from `bb`).
   */
  predicate strictlyPostDominates(BasicBlock bb) { super.strictlyPostDominates(bb) }

  /**
   * Holds if this basic block post-dominates basic block `bb`.
   *
   * That is, all paths reaching a normal exit point basic block from basic
   * block `bb` must go through this basic block.
   */
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
  JoinBlockPredecessor getJoinBlockPredecessor(int i) { result = super.getJoinBlockPredecessor(i) }
}

/** A basic block that is an immediate predecessor of a join block. */
final class JoinBlockPredecessor extends BasicBlock, BasicBlocksImpl::JoinPredecessorBasicBlock { }

/**
 * A basic block that terminates in a condition, splitting the subsequent
 * control flow.
 */
final class ConditionBlock extends BasicBlock, BasicBlocksImpl::ConditionBasicBlock { }
