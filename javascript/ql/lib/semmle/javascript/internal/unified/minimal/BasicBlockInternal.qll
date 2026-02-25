/**
 * Provides classes for working with basic blocks, and predicates for computing
 * liveness information for local variables.
 */
overlay[local?]
module;

import minimal
private import StmtContainers
private import codeql.controlflow.BasicBlock as BB

/**
 * Holds if `nd` starts a new basic block.
 */
private predicate startsBB(ControlFlowNode nd) {
  not exists(nd.getAPredecessor()) and exists(nd.getASuccessor())
  or
  nd.isJoin()
  or
  nd.getAPredecessor().isBranch()
}

/**
 * Holds if the first node of basic block `succ` is a control flow
 * successor of the last node of basic block `bb`.
 */
private predicate succBB(BasicBlock bb, BasicBlock succ) { succ = bb.getLastNode().getASuccessor() }

/**
 * Holds if the first node of basic block `bb` is a control flow
 * successor of the last node of basic block `pre`.
 */
private predicate predBB(BasicBlock bb, BasicBlock pre) { succBB(pre, bb) }

/** Holds if `bb` is an entry basic block. */
private predicate entryBB(BasicBlock bb) { bb.getFirstNode() instanceof ControlFlowEntryNode }

/** Holds if `bb` is an exit basic block. */
private predicate exitBB(BasicBlock bb) { bb.getLastNode() instanceof ControlFlowExitNode }

cached
private module Cached {
  /**
   * Holds if `succ` is a control flow successor of `nd` within the same basic block.
   */
  private predicate intraBBSucc(ControlFlowNode nd, ControlFlowNode succ) {
    succ = nd.getASuccessor() and
    not succ instanceof BasicBlock
  }

  /**
   * Holds if `nd` is the `i`th node in basic block `bb`.
   *
   * In other words, `i` is the shortest distance from a node `bb`
   * that starts a basic block to `nd` along the `intraBBSucc` relation.
   */
  cached
  predicate bbIndex(BasicBlock bb, ControlFlowNode nd, int i) =
    shortestDistances(startsBB/1, intraBBSucc/2)(bb, nd, i)

  cached
  int bbLength(BasicBlock bb) { result = strictcount(ControlFlowNode nd | bbIndex(bb, nd, _)) }

  cached
  predicate reachableBB(BasicBlock bb) {
    entryBB(bb)
    or
    exists(BasicBlock predBB | succBB(predBB, bb) | reachableBB(predBB))
  }
}

private import Cached

/** Gets the immediate dominator of `bb`. */
cached
BasicBlock immediateDominator(BasicBlock bb) = idominance(entryBB/1, succBB/2)(_, result, bb)

/** Gets the immediate post-dominator of `bb`. */
cached
BasicBlock immediatePostDominator(BasicBlock bb) = idominance(exitBB/1, predBB/2)(_, result, bb)

import Public

module Public {
  /**
   * A basic block, that is, a maximal straight-line sequence of control flow nodes
   * without branches or joins.
   *
   * At the database level, a basic block is represented by its first control flow node.
   */
  class BasicBlock extends @cfg_node, NodeInStmtContainer {
    cached
    BasicBlock() { startsBB(this) }

    /** Gets a basic block succeeding this one. */
    BasicBlock getASuccessor() { succBB(this, result) }

    /** Gets a basic block preceding this one. */
    BasicBlock getAPredecessor() { result.getASuccessor() = this }

    /** Gets a node in this block. */
    ControlFlowNode getANode() { result = this.getNode(_) }

    /** Gets the node at the given position in this block. */
    ControlFlowNode getNode(int pos) { bbIndex(this, result, pos) }

    /** Gets the first node in this block. */
    ControlFlowNode getFirstNode() { result = this }

    /** Gets the last node in this block. */
    ControlFlowNode getLastNode() { result = this.getNode(this.length() - 1) }

    /** Gets the length of this block. */
    int length() { result = bbLength(this) }

    /**
     * Gets the basic block that immediately dominates this basic block.
     */
    ReachableBasicBlock getImmediateDominator() { result = immediateDominator(this) }

    /**
     * Holds if this if a basic block whose last node is an exit node.
     */
    predicate isExitBlock() { exitBB(this) }
  }

  /**
   * An unreachable basic block, that is, a basic block
   * whose first node is unreachable.
   */
  class UnreachableBlock extends BasicBlock {
    UnreachableBlock() { this.getFirstNode().isUnreachable() }
  }

  /**
   * An entry basic block, that is, a basic block
   * whose first node is the entry node of a statement container.
   */
  class EntryBasicBlock extends BasicBlock {
    EntryBasicBlock() { entryBB(this) }
  }

  /**
   * A basic block that is reachable from an entry basic block.
   */
  class ReachableBasicBlock extends BasicBlock {
    ReachableBasicBlock() { reachableBB(this) }

    /**
     * Holds if this basic block strictly dominates `bb`.
     */
    overlay[caller?]
    pragma[inline]
    predicate strictlyDominates(ReachableBasicBlock bb) { this = immediateDominator+(bb) }

    /**
     * Holds if this basic block dominates `bb`.
     *
     * This predicate is reflexive: each reachable basic block dominates itself.
     */
    overlay[caller?]
    pragma[inline]
    predicate dominates(ReachableBasicBlock bb) { this = immediateDominator*(bb) }

    /**
     * Holds if this basic block strictly post-dominates `bb`.
     */
    overlay[caller?]
    pragma[inline]
    predicate strictlyPostDominates(ReachableBasicBlock bb) { this = immediatePostDominator+(bb) }

    /**
     * Holds if this basic block post-dominates `bb`.
     *
     * This predicate is reflexive: each reachable basic block post-dominates itself.
     */
    overlay[caller?]
    pragma[inline]
    predicate postDominates(ReachableBasicBlock bb) { this = immediatePostDominator*(bb) }
  }

  /**
   * A reachable basic block with more than one predecessor.
   */
  class ReachableJoinBlock extends ReachableBasicBlock {
    ReachableJoinBlock() { this.getFirstNode().isJoin() }

    /**
     * Holds if this basic block belongs to the dominance frontier of `b`, that is
     * `b` dominates a predecessor of this block, but not this block itself.
     *
     * Algorithm from Cooper et al., "A Simple, Fast Dominance Algorithm" (Figure 5),
     * who in turn attribute it to Ferrante et al., "The program dependence graph and
     * its use in optimization".
     */
    predicate inDominanceFrontierOf(ReachableBasicBlock b) {
      b = this.getAPredecessor() and not b = this.getImmediateDominator()
      or
      exists(ReachableBasicBlock prev | this.inDominanceFrontierOf(prev) |
        b = prev.getImmediateDominator() and
        not b = this.getImmediateDominator()
      )
    }
  }

  final private class FinalBasicBlock = BasicBlock;

  module Cfg implements BB::CfgSig<Location> {
    private import minimal as Js
    private import codeql.controlflow.SuccessorType

    class ControlFlowNode = Js::ControlFlowNode;

    private predicate conditionSucc(BasicBlock bb1, BasicBlock bb2, boolean branch) {
      exists(ConditionGuardNode g |
        bb1 = g.getTest().getBasicBlock() and
        bb2 = g.getBasicBlock() and
        branch = g.getOutcome()
      )
    }

    class BasicBlock extends FinalBasicBlock {
      BasicBlock getASuccessor() { result = super.getASuccessor() }

      BasicBlock getASuccessor(SuccessorType t) {
        conditionSucc(this, result, t.(BooleanSuccessor).getValue())
        or
        result = super.getASuccessor() and
        t instanceof DirectSuccessor and
        not conditionSucc(this, result, _)
      }

      predicate strictlyDominates(BasicBlock bb) {
        this.(ReachableBasicBlock).strictlyDominates(bb)
      }

      predicate dominates(BasicBlock bb) { this.(ReachableBasicBlock).dominates(bb) }

      predicate inDominanceFrontier(BasicBlock df) {
        df.(ReachableJoinBlock).inDominanceFrontierOf(this)
      }

      BasicBlock getImmediateDominator() { result = super.getImmediateDominator() }

      predicate strictlyPostDominates(BasicBlock bb) {
        this.(ReachableBasicBlock).strictlyPostDominates(bb)
      }

      predicate postDominates(BasicBlock bb) { this.(ReachableBasicBlock).postDominates(bb) }
    }

    class EntryBasicBlock extends BasicBlock {
      EntryBasicBlock() { entryBB(this) }
    }

    pragma[nomagic]
    predicate dominatingEdge(BasicBlock bb1, BasicBlock bb2) {
      bb1.getASuccessor() = bb2 and
      bb1 = bb2.getImmediateDominator() and
      forall(BasicBlock pred | pred = bb2.getAPredecessor() and pred != bb1 | bb2.dominates(pred))
    }
  }
}
