/** Provides classes representing basic blocks. */

private import swift
private import ControlFlowGraph
private import internal.ControlFlowGraphImpl as CfgImpl
private import CfgImpl::BasicBlocks as BasicBlocksImpl
private import codeql.controlflow.BasicBlock as BB

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

  predicate edgeDominates(BasicBlock dominated, SuccessorType s) {
    super.edgeDominates(dominated, s)
  }

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
final class ConditionBlock extends BasicBlock, BasicBlocksImpl::ConditionBasicBlock { }

private class BasicBlockAlias = BasicBlock;

private class EntryBasicBlockAlias = EntryBasicBlock;

private class ControlFlowNodeAlias = ControlFlowNode;

module Cfg implements BB::CfgSig<Location> {
  class ControlFlowNode = ControlFlowNodeAlias;

  class BasicBlock = BasicBlockAlias;

  class EntryBasicBlock = EntryBasicBlockAlias;

  predicate dominatingEdge(BasicBlock bb1, BasicBlock bb2) {
    BasicBlocksImpl::dominatingEdge(bb1, bb2)
  }
}
