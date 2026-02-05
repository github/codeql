/**
 * Provides classes for working with basic blocks.
 */

import go
private import ControlFlowGraphImpl
private import codeql.controlflow.BasicBlock as BB
private import codeql.controlflow.SuccessorType

private module Input implements BB::InputSig<Location> {
  /** A delineated part of the AST with its own CFG. */
  class CfgScope = ControlFlow::Root;

  /** The class of control flow nodes. */
  class Node = ControlFlowNode;

  /** Gets the CFG scope in which this node occurs. */
  CfgScope nodeGetCfgScope(Node node) { node.getRoot() = result }

  /** Gets an immediate successor of this node. */
  Node nodeGetASuccessor(Node node, SuccessorType t) {
    result = node.getASuccessor() and
    (
      not result instanceof ControlFlow::ConditionGuardNode and t instanceof DirectSuccessor
      or
      t.(BooleanSuccessor).getValue() = result.(ControlFlow::ConditionGuardNode).getOutcome()
    )
  }

  /**
   * Holds if `node` represents an entry node to be used when calculating
   * dominance.
   */
  predicate nodeIsDominanceEntry(Node node) { node instanceof EntryNode }

  /**
   * Holds if `node` represents an exit node to be used when calculating
   * post dominance.
   */
  predicate nodeIsPostDominanceExit(Node node) { node instanceof ExitNode }
}

private module BbImpl = BB::Make<Location, Input>;

class BasicBlock = BbImpl::BasicBlock;

class EntryBasicBlock = BbImpl::EntryBasicBlock;

cached
private predicate reachableBB(BasicBlock bb) {
  bb instanceof EntryBasicBlock
  or
  exists(BasicBlock predBB | predBB.getASuccessor(_) = bb | reachableBB(predBB))
}

/**
 * A basic block that is reachable from an entry basic block.
 */
class ReachableBasicBlock extends BasicBlock {
  ReachableBasicBlock() { reachableBB(this) }
}

/**
 * A reachable basic block with more than one predecessor.
 */
class ReachableJoinBlock extends ReachableBasicBlock {
  ReachableJoinBlock() { this.getFirstNode().isJoin() }
}
