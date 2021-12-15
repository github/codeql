/**
 * Provides classes for working with basic blocks, and predicates for computing
 * liveness information for local variables.
 */

import javascript
private import internal.StmtContainers
private import semmle.javascript.internal.CachedStages

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
private module Internal {
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
  predicate useAt(BasicBlock bb, int i, Variable v, VarUse u) {
    Stages::BasicBlocks::ref() and
    v = u.getVariable() and
    bbIndex(bb, u, i)
  }

  cached
  predicate defAt(BasicBlock bb, int i, Variable v, VarDef d) {
    exists(VarRef lhs |
      lhs = d.getTarget().(BindingPattern).getABindingVarRef() and
      v = lhs.getVariable()
    |
      lhs = d.getTarget() and
      bbIndex(bb, d, i)
      or
      exists(PropertyPattern pp |
        lhs = pp.getValuePattern() and
        bbIndex(bb, pp, i)
      )
      or
      exists(ObjectPattern op |
        lhs = op.getRest() and
        bbIndex(bb, lhs, i)
      )
      or
      exists(ArrayPattern ap |
        lhs = ap.getAnElement() and
        bbIndex(bb, lhs, i)
      )
    )
  }

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
class BasicBlock extends @cfg_node, NodeInStmtContainer {
  cached
  BasicBlock() { Stages::BasicBlocks::ref() and startsBB(this) }

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

  /** Holds if this basic block uses variable `v` in its `i`th node `u`. */
  predicate useAt(int i, Variable v, VarUse u) { useAt(this, i, v, u) }

  /** Holds if this basic block defines variable `v` in its `i`th node `u`. */
  predicate defAt(int i, Variable v, VarDef d) { defAt(this, i, v, d) }

  /**
   * Holds if `v` is live at entry to this basic block and `u` is a use of `v`
   * witnessing the liveness.
   *
   * In other words, `u` is a use of `v` that is reachable from the
   * entry node of this basic block without going through a redefinition
   * of `v`. The use `u` may either be in this basic block, or in another
   * basic block reachable from this one.
   */
  predicate isLiveAtEntry(Variable v, VarUse u) {
    // restrict `u` to be reachable from this basic block
    u = this.getASuccessor*().getANode() and
    (
      // shortcut: if `v` is never defined, then it must be live
      this.isDefinedInSameContainer(v)
      implies
      // otherwise, do full liveness computation
      this.isLiveAtEntryImpl(v, u)
    )
  }

  /**
   * Holds if `v` is live at entry to this basic block and `u` is a use of `v`
   * witnessing the liveness, where `v` is defined at least once in the enclosing
   * function or script.
   */
  private predicate isLiveAtEntryImpl(Variable v, VarUse u) {
    this.isLocallyLiveAtEntry(v, u)
    or
    this.isDefinedInSameContainer(v) and
    not this.defAt(_, v, _) and
    this.getASuccessor().isLiveAtEntryImpl(v, u)
  }

  /**
   * Holds if `v` is defined at least once in the function or script to which
   * this basic block belongs.
   */
  private predicate isDefinedInSameContainer(Variable v) {
    exists(VarDef def | def.getAVariable() = v and def.getContainer() = this.getContainer())
  }

  /**
   * Holds if `v` is a variable that is live at entry to this basic block.
   *
   * Note that this is equivalent to `bb.isLiveAtEntry(v, _)`, but may
   * be more efficient on large databases.
   */
  predicate isLiveAtEntry(Variable v) {
    this.isLocallyLiveAtEntry(v, _)
    or
    not this.defAt(_, v, _) and this.getASuccessor().isLiveAtEntry(v)
  }

  /**
   * Holds if local variable `v` is live at entry to this basic block and
   * `u` is a use of `v` witnessing the liveness.
   */
  predicate localIsLiveAtEntry(LocalVariable v, VarUse u) {
    this.isLocallyLiveAtEntry(v, u)
    or
    not this.defAt(_, v, _) and this.getASuccessor().localIsLiveAtEntry(v, u)
  }

  /**
   * Holds if local variable `v` is live at entry to this basic block.
   */
  predicate localIsLiveAtEntry(LocalVariable v) {
    this.isLocallyLiveAtEntry(v, _)
    or
    not this.defAt(_, v, _) and this.getASuccessor().localIsLiveAtEntry(v)
  }

  /**
   * Holds if `d` is a definition of `v` that is reachable from the beginning of
   * this basic block without going through a redefinition of `v`.
   */
  predicate localMayBeOverwritten(LocalVariable v, VarDef d) {
    this.isLocallyOverwritten(v, d)
    or
    not this.defAt(_, v, _) and this.getASuccessor().localMayBeOverwritten(v, d)
  }

  /**
   * Gets the next index after `i` in this basic block at which `v` is
   * defined or used, provided that `d` is a definition of `v` at index `i`.
   * If there are no further uses or definitions of `v` after `i`, the
   * result is the length of this basic block.
   */
  private int nextDefOrUseAfter(PurelyLocalVariable v, int i, VarDef d) {
    this.defAt(i, v, d) and
    result =
      min(int j |
        (this.defAt(j, v, _) or this.useAt(j, v, _) or j = this.length()) and
        j > i
      )
  }

  /**
   * Holds if `d` defines variable `v` at the `i`th node of this basic block, and
   * the definition is live, that is, the variable may be read after this
   * definition and before a re-definition.
   */
  predicate localLiveDefAt(PurelyLocalVariable v, int i, VarDef d) {
    exists(int j | j = this.nextDefOrUseAfter(v, i, d) |
      this.useAt(j, v, _)
      or
      j = this.length() and this.getASuccessor().localIsLiveAtEntry(v)
    )
  }

  /**
   * Holds if `u` is a use of `v` in this basic block, and there are
   * no definitions of `v` before it.
   */
  private predicate isLocallyLiveAtEntry(Variable v, VarUse u) {
    exists(int n | this.useAt(n, v, u) | not exists(int m | m < n | this.defAt(m, v, _)))
  }

  /**
   * Holds if `d` is a definition of `v` in this basic block, and there are
   * no other definitions of `v` before it.
   */
  private predicate isLocallyOverwritten(Variable v, VarDef d) {
    exists(int n | this.defAt(n, v, d) | not exists(int m | m < n | this.defAt(m, v, _)))
  }

  /**
   * Gets the basic block that immediately dominates this basic block.
   */
  ReachableBasicBlock getImmediateDominator() { bbIDominates(result, this) }
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
  pragma[inline]
  predicate strictlyDominates(ReachableBasicBlock bb) { bbIDominates+(this, bb) }

  /**
   * Holds if this basic block dominates `bb`.
   *
   * This predicate is reflexive: each reachable basic block dominates itself.
   */
  pragma[inline]
  predicate dominates(ReachableBasicBlock bb) { bbIDominates*(this, bb) }

  /**
   * Holds if this basic block strictly post-dominates `bb`.
   */
  pragma[inline]
  predicate strictlyPostDominates(ReachableBasicBlock bb) { bbIPostDominates+(this, bb) }

  /**
   * Holds if this basic block post-dominates `bb`.
   *
   * This predicate is reflexive: each reachable basic block post-dominates itself.
   */
  pragma[inline]
  predicate postDominates(ReachableBasicBlock bb) { bbIPostDominates*(this, bb) }
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
