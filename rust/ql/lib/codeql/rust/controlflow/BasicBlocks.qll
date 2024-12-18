private import rust
private import ControlFlowGraph
private import internal.SuccessorType
private import internal.ControlFlowGraphImpl as Impl
private import codeql.rust.elements.internal.generated.Raw
private import codeql.rust.elements.internal.generated.Synth

final class BasicBlock = BasicBlockImpl;

/**
 * A basic block, that is, a maximal straight-line sequence of control flow nodes
 * without branches or joins.
 */
private class BasicBlockImpl extends TBasicBlockStart {
  /** Gets the CFG scope of this basic block. */
  CfgScope getScope() { result = this.getAPredecessor().getScope() }

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

  predicate immediatelyDominates(BasicBlock bb) { bbIDominates(this, bb) }

  predicate strictlyDominates(BasicBlock bb) { bbIDominates+(this, bb) }

  predicate dominates(BasicBlock bb) {
    bb = this or
    this.strictlyDominates(bb)
  }

  predicate inDominanceFrontier(BasicBlock df) {
    this.dominatesPredecessor(df) and
    not this.strictlyDominates(df)
  }

  /**
   * Holds if this basic block dominates a predecessor of `df`.
   */
  private predicate dominatesPredecessor(BasicBlock df) { this.dominates(df.getAPredecessor()) }

  BasicBlock getImmediateDominator() { bbIDominates(result, this) }

  predicate strictlyPostDominates(BasicBlock bb) { bbIPostDominates+(this, bb) }

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
  private predicate normalExitBB(BasicBlock bb) {
    bb.getANode().(Impl::AnnotatedExitNode).isNormal()
  }

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
}

private import Cached

/** Holds if `bb` is an entry basic block. */
private predicate entryBB(BasicBlock bb) { bb.getFirstNode() instanceof Impl::EntryNode }

/**
 * An entry basic block, that is, a basic block whose first node is
 * an entry node.
 */
class EntryBasicBlock extends BasicBlockImpl {
  EntryBasicBlock() { entryBB(this) }

  override CfgScope getScope() {
    this.getFirstNode() = any(Impl::EntryNode node | node.getScope() = result)
  }
}

/**
 * An annotated exit basic block, that is, a basic block whose last node is
 * an annotated exit node.
 */
class AnnotatedExitBasicBlock extends BasicBlockImpl {
  private boolean normal;

  AnnotatedExitBasicBlock() {
    exists(Impl::AnnotatedExitNode n |
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
class ExitBasicBlock extends BasicBlockImpl {
  ExitBasicBlock() { this.getLastNode() instanceof Impl::ExitNode }
}

private module JoinBlockPredecessors {
  private predicate id(Raw::AstNode x, Raw::AstNode y) { x = y }

  private predicate idOfDbAstNode(Raw::AstNode x, int y) = equivalenceRelation(id/2)(x, y)

  // TODO: does not work if fresh ipa entities (`ipa: on:`) turn out to be first of the block
  private predicate idOf(AstNode x, int y) { idOfDbAstNode(Synth::convertAstNodeToRaw(x), y) }

  int getId(JoinBlockPredecessor jbp) {
    idOf(jbp.getFirstNode().(Impl::AstCfgNode).getAstNode(), result)
    or
    idOf(jbp.(EntryBasicBlock).getScope(), result)
  }

  string getSplitString(JoinBlockPredecessor jbp) {
    result = jbp.getFirstNode().(Impl::AstCfgNode).getSplitsString()
    or
    not exists(jbp.getFirstNode().(Impl::AstCfgNode).getSplitsString()) and
    result = ""
  }
}

/** A basic block with more than one predecessor. */
class JoinBlock extends BasicBlockImpl {
  JoinBlock() { this.getFirstNode().isJoin() }

  /**
   * Gets the `i`th predecessor of this join block, with respect to some
   * arbitrary order.
   */
  JoinBlockPredecessor getJoinBlockPredecessor(int i) { result = getJoinBlockPredecessor(this, i) }
}

/** A basic block that is an immediate predecessor of a join block. */
class JoinBlockPredecessor extends BasicBlockImpl {
  JoinBlockPredecessor() { this.getASuccessor() instanceof JoinBlock }
}

/** A basic block that terminates in a condition, splitting the subsequent control flow. */
class ConditionBlock extends BasicBlockImpl {
  ConditionBlock() { this.getLastNode().isCondition() }

  /**
   * Holds if basic block `succ` is immediately controlled by this basic
   * block with conditional value `s`. That is, `succ` is an immediate
   * successor of this block, and `succ` can only be reached from
   * the callable entry point by going via the `s` edge out of this basic block.
   */
  pragma[nomagic]
  predicate immediatelyControls(BasicBlock succ, SuccessorType s) {
    succ = this.getASuccessor(s) and
    forall(BasicBlock pred | pred = succ.getAPredecessor() and pred != this | succ.dominates(pred))
  }

  /**
   * Holds if basic block `controlled` is controlled by this basic block with
   * conditional value `s`. That is, `controlled` can only be reached from
   * the callable entry point by going via the `s` edge out of this basic block.
   */
  predicate controls(BasicBlock controlled, BooleanSuccessor s) {
    exists(BasicBlock succ | this.immediatelyControls(succ, s) | succ.dominates(controlled))
  }
}
