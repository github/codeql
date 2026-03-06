/** Provides classes representing basic blocks. */

private import codeql.php.AST
private import codeql.php.controlflow.ControlFlowGraph
private import internal.ControlFlowGraphImpl as CfgImpl
private import CfgImpl::BasicBlocks as BasicBlocksImpl
private import codeql.controlflow.BasicBlock as BB
private import codeql.controlflow.SuccessorType

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

  /** Gets the control flow node at position `pos` in this basic block. */
  CfgNode getNode(int pos) { result = super.getNode(pos) }

  /** Gets a control flow node in this basic block. */
  CfgNode getANode() { result = super.getANode() }

  /** Gets the first control flow node in this basic block. */
  CfgNode getFirstNode() { result = super.getFirstNode() }

  /** Gets the last control flow node in this basic block. */
  CfgNode getLastNode() { result = super.getLastNode() }

  /** Holds if this basic block immediately dominates basic block `bb`. */
  predicate immediatelyDominates(BasicBlock bb) { super.immediatelyDominates(bb) }

  /** Holds if this basic block strictly dominates basic block `bb`. */
  predicate strictlyDominates(BasicBlock bb) { super.strictlyDominates(bb) }

  /** Holds if this basic block dominates basic block `bb`. */
  predicate dominates(BasicBlock bb) { super.dominates(bb) }

  /**
   * Holds if `df` is in the dominance frontier of this basic block.
   */
  predicate inDominanceFrontier(BasicBlock df) { super.inDominanceFrontier(df) }

  /** Gets the basic block that immediately dominates this basic block, if any. */
  BasicBlock getImmediateDominator() { result = super.getImmediateDominator() }

  /** Holds if this basic block strictly post-dominates basic block `bb`. */
  predicate strictlyPostDominates(BasicBlock bb) { super.strictlyPostDominates(bb) }

  /** Holds if this basic block post-dominates basic block `bb`. */
  predicate postDominates(BasicBlock bb) { super.postDominates(bb) }
}

/** An entry basic block. */
final class EntryBasicBlock extends BasicBlock, BasicBlocksImpl::EntryBasicBlock { }

/** An annotated exit basic block. */
final class AnnotatedExitBasicBlock extends BasicBlock, BasicBlocksImpl::AnnotatedExitBasicBlock { }

/** An exit basic block. */
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

private class BasicBlockAlias = BasicBlock;

private class EntryBasicBlockAlias = EntryBasicBlock;

/** Implements the `CfgSig` module for use by the SSA library. */
module Cfg implements BB::CfgSig<Location> {
  class ControlFlowNode = CfgNode;

  class BasicBlock = BasicBlockAlias;

  class EntryBasicBlock = EntryBasicBlockAlias;

  predicate dominatingEdge(BasicBlock bb1, BasicBlock bb2) {
    BasicBlocksImpl::dominatingEdge(bb1, bb2)
  }
}
