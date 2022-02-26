/** Provides classes representing basic blocks. */

private import codeql.Locations
private import codeql.ruby.AST
private import codeql.ruby.ast.internal.AST
private import codeql.ruby.ast.internal.TreeSitter
private import codeql.ruby.controlflow.ControlFlowGraph
private import internal.ControlFlowGraphImpl
private import CfgNodes
private import SuccessorTypes

/**
 * A basic block, that is, a maximal straight-line sequence of control flow nodes
 * without branches or joins.
 */
class BasicBlock extends TBasicBlockStart {
  /** Gets the scope of this basic block. */
  final CfgScope getScope() { result = this.getFirstNode().getScope() }

  /** Gets an immediate successor of this basic block, if any. */
  BasicBlock getASuccessor() { result = this.getASuccessor(_) }

  /** Gets an immediate successor of this basic block of a given type, if any. */
  BasicBlock getASuccessor(SuccessorType t) {
    result.getFirstNode() = this.getLastNode().getASuccessor(t)
  }

  /** Gets an immediate predecessor of this basic block, if any. */
  BasicBlock getAPredecessor() { result.getASuccessor() = this }

  /** Gets an immediate predecessor of this basic block of a given type, if any. */
  BasicBlock getAPredecessor(SuccessorType t) { result.getASuccessor(t) = this }

  /** Gets the control flow node at a specific (zero-indexed) position in this basic block. */
  CfgNode getNode(int pos) { bbIndex(this.getFirstNode(), result, pos) }

  /** Gets a control flow node in this basic block. */
  CfgNode getANode() { result = this.getNode(_) }

  /** Gets the first control flow node in this basic block. */
  CfgNode getFirstNode() { this = TBasicBlockStart(result) }

  /** Gets the last control flow node in this basic block. */
  CfgNode getLastNode() { result = this.getNode(this.length() - 1) }

  /** Gets the length of this basic block. */
  int length() { result = strictcount(this.getANode()) }

  /**
   * Holds if this basic block immediately dominates basic block `bb`.
   *
   * That is, all paths reaching basic block `bb` from some entry point
   * basic block must go through this basic block (which is an immediate
   * predecessor of `bb`).
   *
   * Example:
   *
   * ```rb
   * def m b
   *   if b
   *     return 0
   *   end
   *   return 1
   * end
   * ```
   *
   * The basic block starting on line 2 immediately dominates the
   * basic block on line 5 (all paths from the entry point of `m`
   * to `return 1` must go through the `if` block).
   */
  predicate immediatelyDominates(BasicBlock bb) { bbIDominates(this, bb) }

  /**
   * Holds if this basic block strictly dominates basic block `bb`.
   *
   * That is, all paths reaching basic block `bb` from some entry point
   * basic block must go through this basic block (which must be different
   * from `bb`).
   *
   * Example:
   *
   * ```rb
   * def m b
   *   if b
   *     return 0
   *   end
   *   return 1
   * end
   * ```
   *
   * The basic block starting on line 2 strictly dominates the
   * basic block on line 5 (all paths from the entry point of `m`
   * to `return 1` must go through the `if` block).
   */
  predicate strictlyDominates(BasicBlock bb) { bbIDominates+(this, bb) }

  /**
   * Holds if this basic block dominates basic block `bb`.
   *
   * That is, all paths reaching basic block `bb` from some entry point
   * basic block must go through this basic block.
   *
   * Example:
   *
   * ```rb
   * def m b
   *   if b
   *     return 0
   *   end
   *   return 1
   * end
   * ```
   *
   * The basic block starting on line 2 dominates the basic
   * basic block on line 5 (all paths from the entry point of `m`
   * to `return 1` must go through the `if` block).
   */
  predicate dominates(BasicBlock bb) {
    bb = this or
    this.strictlyDominates(bb)
  }

  /**
   * Holds if `df` is in the dominance frontier of this basic block.
   * That is, this basic block dominates a predecessor of `df`, but
   * does not dominate `df` itself.
   *
   * Example:
   *
   * ```rb
   * def m x
   *   if x < 0
   *     x = -x
   *     if x > 10
   *       x = x - 1
   *     end
   *   end
   *   puts x
   * end
   * ```
   *
   * The basic block on line 8 is in the dominance frontier
   * of the basic block starting on line 3 because that block
   * dominates the basic block on line 4, which is a predecessor of
   * `puts x`. Also, the basic block starting on line 3 does not
   * dominate the basic block on line 8.
   */
  predicate inDominanceFrontier(BasicBlock df) {
    this.dominatesPredecessor(df) and
    not this.strictlyDominates(df)
  }

  /**
   * Holds if this basic block dominates a predecessor of `df`.
   */
  private predicate dominatesPredecessor(BasicBlock df) { this.dominates(df.getAPredecessor()) }

  /**
   * Gets the basic block that immediately dominates this basic block, if any.
   *
   * That is, all paths reaching this basic block from some entry point
   * basic block must go through the result, which is an immediate basic block
   * predecessor of this basic block.
   *
   * Example:
   *
   * ```rb
   * def m b
   *   if b
   *     return 0
   *   end
   *   return 1
   * end
   * ```
   *
   * The basic block starting on line 2 is an immediate dominator of
   * the basic block on line 5 (all paths from the entry point of `m`
   * to `return 1` must go through the `if` block, and the `if` block
   * is an immediate predecessor of `return 1`).
   */
  BasicBlock getImmediateDominator() { bbIDominates(result, this) }

  /**
   * Holds if this basic block strictly post-dominates basic block `bb`.
   *
   * That is, all paths reaching a normal exit point basic block from basic
   * block `bb` must go through this basic block (which must be different
   * from `bb`).
   *
   * Example:
   *
   * ```rb
   * def m b
   *   if b
   *     puts "b"
   *   end
   *   puts "m"
   * end
   * ```
   *
   * The basic block on line 5 strictly post-dominates the basic block on
   * line 3 (all paths to the exit point of `m` from `puts "b"` must go
   * through `puts "m"`).
   */
  predicate strictlyPostDominates(BasicBlock bb) { bbIPostDominates+(this, bb) }

  /**
   * Holds if this basic block post-dominates basic block `bb`.
   *
   * That is, all paths reaching a normal exit point basic block from basic
   * block `bb` must go through this basic block.
   *
   * Example:
   *
   * ```rb
   * def m b
   *   if b
   *     puts "b"
   *   end
   *   puts "m"
   * end
   * ```
   *
   * The basic block on line 5 post-dominates the basic block on line 3
   * (all paths to the exit point of `m` from `puts "b"` must go through
   * `puts "m"`).
   */
  predicate postDominates(BasicBlock bb) {
    this.strictlyPostDominates(bb) or
    this = bb
  }

  /** Holds if this basic block is in a loop in the control flow graph. */
  predicate inLoop() { this.getASuccessor+() = this }

  /** Gets a textual representation of this basic block. */
  string toString() { result = this.getFirstNode().toString() }

  /** Gets the location of this basic block. */
  Location getLocation() { result = this.getFirstNode().getLocation() }
}

cached
private module Cached {
  /** Internal representation of basic blocks. */
  cached
  newtype TBasicBlock = TBasicBlockStart(CfgNode cfn) { startsBB(cfn) }

  /** Holds if `cfn` starts a new basic block. */
  private predicate startsBB(CfgNode cfn) {
    not exists(cfn.getAPredecessor()) and exists(cfn.getASuccessor())
    or
    cfn.isJoin()
    or
    cfn.getAPredecessor().isBranch()
  }

  /**
   * Holds if `succ` is a control flow successor of `pred` within
   * the same basic block.
   */
  private predicate intraBBSucc(CfgNode pred, CfgNode succ) {
    succ = pred.getASuccessor() and
    not startsBB(succ)
  }

  /**
   * Holds if `cfn` is the `i`th node in basic block `bb`.
   *
   * In other words, `i` is the shortest distance from a node `bb`
   * that starts a basic block to `cfn` along the `intraBBSucc` relation.
   */
  cached
  predicate bbIndex(CfgNode bbStart, CfgNode cfn, int i) =
    shortestDistances(startsBB/1, intraBBSucc/2)(bbStart, cfn, i)

  /**
   * Holds if the first node of basic block `succ` is a control flow
   * successor of the last node of basic block `pred`.
   */
  private predicate succBB(BasicBlock pred, BasicBlock succ) { succ = pred.getASuccessor() }

  /** Holds if `dom` is an immediate dominator of `bb`. */
  cached
  predicate bbIDominates(BasicBlock dom, BasicBlock bb) =
    idominance(entryBB/1, succBB/2)(_, dom, bb)

  /** Holds if `pred` is a basic block predecessor of `succ`. */
  private predicate predBB(BasicBlock succ, BasicBlock pred) { succBB(pred, succ) }

  /** Holds if `bb` is an exit basic block that represents normal exit. */
  private predicate normalExitBB(BasicBlock bb) { bb.getANode().(AnnotatedExitNode).isNormal() }

  /** Holds if `dom` is an immediate post-dominator of `bb`. */
  cached
  predicate bbIPostDominates(BasicBlock dom, BasicBlock bb) =
    idominance(normalExitBB/1, predBB/2)(_, dom, bb)

  /**
   * Gets the `i`th predecessor of join block `jb`, with respect to some
   * arbitrary order.
   */
  cached
  JoinBlockPredecessor getJoinBlockPredecessor(JoinBlock jb, int i) {
    result =
      rank[i + 1](JoinBlockPredecessor jbp |
        jbp = jb.getAPredecessor()
      |
        jbp order by JoinBlockPredecessors::getId(jbp), JoinBlockPredecessors::getSplitString(jbp)
      )
  }

  cached
  predicate immediatelyControls(ConditionBlock cb, BasicBlock succ, BooleanSuccessor s) {
    succ = cb.getASuccessor(s) and
    forall(BasicBlock pred | pred = succ.getAPredecessor() and pred != cb | succ.dominates(pred))
  }

  cached
  predicate controls(ConditionBlock cb, BasicBlock controlled, BooleanSuccessor s) {
    exists(BasicBlock succ | cb.immediatelyControls(succ, s) | succ.dominates(controlled))
  }
}

private import Cached

/** Holds if `bb` is an entry basic block. */
private predicate entryBB(BasicBlock bb) { bb.getFirstNode() instanceof EntryNode }

/**
 * An entry basic block, that is, a basic block whose first node is
 * an entry node.
 */
class EntryBasicBlock extends BasicBlock {
  EntryBasicBlock() { entryBB(this) }
}

/**
 * An annotated exit basic block, that is, a basic block whose last node is
 * an annotated exit node.
 */
class AnnotatedExitBasicBlock extends BasicBlock {
  private boolean normal;

  AnnotatedExitBasicBlock() {
    exists(AnnotatedExitNode n |
      n = this.getANode() and
      if n.isNormal() then normal = true else normal = false
    )
  }

  /** Holds if this block represent a normal exit. */
  final predicate isNormal() { normal = true }
}

/**
 * An exit basic block, that is, a basic block whose last node is
 * an exit node.
 */
class ExitBasicBlock extends BasicBlock {
  ExitBasicBlock() { this.getLastNode() instanceof ExitNode }
}

private module JoinBlockPredecessors {
  private predicate id(Ruby::AstNode x, Ruby::AstNode y) { x = y }

  private predicate idOf(Ruby::AstNode x, int y) = equivalenceRelation(id/2)(x, y)

  int getId(JoinBlockPredecessor jbp) {
    idOf(toGeneratedInclSynth(jbp.getFirstNode().(AstCfgNode).getNode()), result)
    or
    idOf(toGeneratedInclSynth(jbp.(EntryBasicBlock).getScope()), result)
  }

  string getSplitString(JoinBlockPredecessor jbp) {
    result = jbp.getFirstNode().(AstCfgNode).getSplitsString()
    or
    not exists(jbp.getFirstNode().(AstCfgNode).getSplitsString()) and
    result = ""
  }
}

/** A basic block with more than one predecessor. */
class JoinBlock extends BasicBlock {
  JoinBlock() { this.getFirstNode().isJoin() }

  /**
   * Gets the `i`th predecessor of this join block, with respect to some
   * arbitrary order.
   */
  JoinBlockPredecessor getJoinBlockPredecessor(int i) { result = getJoinBlockPredecessor(this, i) }
}

/** A basic block that is an immediate predecessor of a join block. */
class JoinBlockPredecessor extends BasicBlock {
  JoinBlockPredecessor() { this.getASuccessor() instanceof JoinBlock }
}

/** A basic block that terminates in a condition, splitting the subsequent control flow. */
class ConditionBlock extends BasicBlock {
  ConditionBlock() { this.getLastNode().isCondition() }

  /**
   * Holds if basic block `succ` is immediately controlled by this basic
   * block with conditional value `s`. That is, `succ` is an immediate
   * successor of this block, and `succ` can only be reached from
   * the callable entry point by going via the `s` edge out of this basic block.
   */
  predicate immediatelyControls(BasicBlock succ, BooleanSuccessor s) {
    immediatelyControls(this, succ, s)
  }

  /**
   * Holds if basic block `controlled` is controlled by this basic block with
   * conditional value `s`. That is, `controlled` can only be reached from
   * the callable entry point by going via the `s` edge out of this basic block.
   */
  predicate controls(BasicBlock controlled, BooleanSuccessor s) { controls(this, controlled, s) }
}
