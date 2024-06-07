/**
 * Provides classes for working with basic blocks.
 */

import go
private import ControlFlowGraphImpl

/**
 * Holds if `nd` starts a new basic block.
 */
private predicate startsBB(ControlFlow::Node nd) {
  count(nd.getAPredecessor()) != 1
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
private predicate entryBB(BasicBlock bb) { bb.getFirstNode().isEntryNode() }

/** Holds if `bb` is an exit basic block. */
private predicate exitBB(BasicBlock bb) { bb.getLastNode().isExitNode() }

cached
private module Internal {
  /**
   * Holds if `succ` is a control flow successor of `nd` within the same basic block.
   */
  private predicate intraBBSucc(ControlFlow::Node nd, ControlFlow::Node succ) {
    succ = nd.getASuccessor() and
    not startsBB(succ)
  }

  /**
   * Holds if `nd` is the `i`th node in basic block `bb`.
   *
   * In other words, `i` is the shortest distance from a node `bb`
   * that starts a basic block to `nd` along the `intraBBSucc` relation.
   */
  cached
  predicate bbIndex(BasicBlock bb, ControlFlow::Node nd, int i) =
    shortestDistances(startsBB/1, intraBBSucc/2)(bb, nd, i)

  cached
  int bbLength(BasicBlock bb) { result = strictcount(ControlFlow::Node nd | bbIndex(bb, nd, _)) }

  cached
  predicate reachableBB(BasicBlock bb) {
    entryBB(bb)
    or
    exists(BasicBlock predBB | succBB(predBB, bb) | reachableBB(predBB))
  }
}

private import Internal

/** Holds if `dom` is an immediate dominator of `bb`. */
cached
private predicate bbIDominates(BasicBlock dom, BasicBlock bb) =
  idominance(entryBB/1, succBB/2)(_, dom, bb)

/** Holds if `dom` is an immediate post-dominator of `bb`. */
cached
private predicate bbIPostDominates(BasicBlock dom, BasicBlock bb) =
  idominance(exitBB/1, predBB/2)(_, dom, bb)

/**
 * A basic block, that is, a maximal straight-line sequence of control flow nodes
 * without branches or joins.
 *
 * At the database level, a basic block is represented by its first control flow node.
 */
class BasicBlock extends TControlFlowNode {
  BasicBlock() { startsBB(this) }

  /** Gets a basic block succeeding this one. */
  BasicBlock getASuccessor() { succBB(this, result) }

  /** Gets a basic block preceding this one. */
  BasicBlock getAPredecessor() { result.getASuccessor() = this }

  /** Gets a node in this block. */
  ControlFlow::Node getANode() { result = this.getNode(_) }

  /** Gets the node at the given position in this block. */
  ControlFlow::Node getNode(int pos) { bbIndex(this, result, pos) }

  /** Gets the first node in this block. */
  ControlFlow::Node getFirstNode() { result = this }

  /** Gets the last node in this block. */
  ControlFlow::Node getLastNode() { result = this.getNode(this.length() - 1) }

  /** Gets the length of this block. */
  int length() { result = bbLength(this) }

  /** Gets the basic block that immediately dominates this basic block. */
  ReachableBasicBlock getImmediateDominator() { bbIDominates(result, this) }

  /** Gets the innermost function or file to which this basic block belongs. */
  ControlFlow::Root getRoot() { result = this.getFirstNode().getRoot() }

  /** Gets a textual representation of this basic block. */
  string toString() { result = "basic block" }

  /**
   * Holds if this basic block is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getFirstNode().hasLocationInfo(filepath, startline, startcolumn, _, _) and
    this.getLastNode().hasLocationInfo(_, _, _, endline, endcolumn)
  }
}

/**
 * An entry basic block, that is, a basic block whose first node is an entry node.
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
  cached
  predicate strictlyDominates(ReachableBasicBlock bb) { bbIDominates+(this, bb) }

  /**
   * Holds if this basic block dominates `bb`.
   *
   * This predicate is reflexive: each reachable basic block dominates itself.
   */
  predicate dominates(ReachableBasicBlock bb) {
    bb = this or
    this.strictlyDominates(bb)
  }

  /**
   * Holds if this basic block strictly post-dominates `bb`.
   */
  cached
  predicate strictlyPostDominates(ReachableBasicBlock bb) { bbIPostDominates+(this, bb) }

  /**
   * Holds if this basic block post-dominates `bb`.
   *
   * This predicate is reflexive: each reachable basic block post-dominates itself.
   */
  predicate postDominates(ReachableBasicBlock bb) {
    bb = this or
    this.strictlyPostDominates(bb)
  }
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
