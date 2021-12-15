/**
 * Provides classes and predicates for control-flow graph dominance.
 */

import java
private import semmle.code.java.ControlFlowGraph

/*
 * Predicates for basic-block-level dominance.
 */

/** Entry points for control-flow. */
private predicate flowEntry(Stmt entry) {
  exists(Callable c | entry = c.getBody())
  or
  // This disjunct is technically superfluous, but safeguards against extractor problems.
  entry instanceof BlockStmt and
  not exists(entry.getEnclosingCallable()) and
  not entry.getParent() instanceof Stmt
}

/** The successor relation for basic blocks. */
private predicate bbSucc(BasicBlock pre, BasicBlock post) { post = pre.getABBSuccessor() }

/** The immediate dominance relation for basic blocks. */
cached
predicate bbIDominates(BasicBlock dom, BasicBlock node) =
  idominance(flowEntry/1, bbSucc/2)(_, dom, node)

/** Holds if the dominance relation is calculated for `bb`. */
predicate hasDominanceInformation(BasicBlock bb) {
  exists(BasicBlock entry | flowEntry(entry) and bbSucc*(entry, bb))
}

/** Exit points for control-flow. */
private predicate flowExit(Callable exit) { exists(ControlFlowNode s | s.getASuccessor() = exit) }

/** Exit points for basic-block control-flow. */
private predicate bbSink(BasicBlock exit) { flowExit(exit.getLastNode()) }

/** Reversed `bbSucc`. */
private predicate bbPred(BasicBlock post, BasicBlock pre) { post = pre.getABBSuccessor() }

/** The immediate post-dominance relation on basic blocks. */
cached
predicate bbIPostDominates(BasicBlock dominator, BasicBlock node) =
  idominance(bbSink/1, bbPred/2)(_, dominator, node)

/** Holds if `dom` strictly dominates `node`. */
predicate bbStrictlyDominates(BasicBlock dom, BasicBlock node) { bbIDominates+(dom, node) }

/** Holds if `dom` dominates `node`. (This is reflexive.) */
predicate bbDominates(BasicBlock dom, BasicBlock node) {
  bbStrictlyDominates(dom, node) or dom = node
}

/** Holds if `dom` strictly post-dominates `node`. */
predicate bbStrictlyPostDominates(BasicBlock dom, BasicBlock node) { bbIPostDominates+(dom, node) }

/** Holds if `dom` post-dominates `node`. (This is reflexive.) */
predicate bbPostDominates(BasicBlock dom, BasicBlock node) {
  bbStrictlyPostDominates(dom, node) or dom = node
}

/**
 * The dominance frontier relation for basic blocks.
 *
 * This is equivalent to:
 *
 * ```
 *   bbDominates(x, w.getABBPredecessor()) and not bbStrictlyDominates(x, w)
 * ```
 */
predicate dominanceFrontier(BasicBlock x, BasicBlock w) {
  x = w.getABBPredecessor() and not bbIDominates(x, w)
  or
  exists(BasicBlock prev | dominanceFrontier(prev, w) |
    bbIDominates(x, prev) and
    not bbIDominates(x, w)
  )
}

/**
 * Holds if `(bb1, bb2)` is an edge that dominates `bb2`, that is, all other
 * predecessors of `bb2` are dominated by `bb2`. This implies that `bb1` is the
 * immediate dominator of `bb2`.
 *
 * This is a necessary and sufficient condition for an edge to dominate anything,
 * and in particular `dominatingEdge(bb1, bb2) and bb2.bbDominates(bb3)` means
 * that the edge `(bb1, bb2)` dominates `bb3`.
 */
predicate dominatingEdge(BasicBlock bb1, BasicBlock bb2) {
  bbIDominates(bb1, bb2) and
  bb1.getABBSuccessor() = bb2 and
  forall(BasicBlock pred | pred = bb2.getABBPredecessor() and pred != bb1 | bbDominates(bb2, pred))
}

/*
 * Predicates for expression-level dominance.
 */

/** Immediate dominance relation on control-flow graph nodes. */
predicate iDominates(ControlFlowNode dominator, ControlFlowNode node) {
  exists(BasicBlock bb, int i | dominator = bb.getNode(i) and node = bb.getNode(i + 1))
  or
  exists(BasicBlock dom, BasicBlock bb |
    bbIDominates(dom, bb) and
    dominator = dom.getLastNode() and
    node = bb.getFirstNode()
  )
}

/** Holds if `dom` strictly dominates `node`. */
pragma[inline]
predicate strictlyDominates(ControlFlowNode dom, ControlFlowNode node) {
  // This predicate is gigantic, so it must be inlined.
  bbStrictlyDominates(dom.getBasicBlock(), node.getBasicBlock())
  or
  exists(BasicBlock b, int i, int j | dom = b.getNode(i) and node = b.getNode(j) and i < j)
}

/** Holds if `dom` dominates `node`. (This is reflexive.) */
pragma[inline]
predicate dominates(ControlFlowNode dom, ControlFlowNode node) {
  // This predicate is gigantic, so it must be inlined.
  bbStrictlyDominates(dom.getBasicBlock(), node.getBasicBlock())
  or
  exists(BasicBlock b, int i, int j | dom = b.getNode(i) and node = b.getNode(j) and i <= j)
}

/** Holds if `dom` strictly post-dominates `node`. */
pragma[inline]
predicate strictlyPostDominates(ControlFlowNode dom, ControlFlowNode node) {
  // This predicate is gigantic, so it must be inlined.
  bbStrictlyPostDominates(dom.getBasicBlock(), node.getBasicBlock())
  or
  exists(BasicBlock b, int i, int j | dom = b.getNode(i) and node = b.getNode(j) and i > j)
}

/** Holds if `dom` post-dominates `node`. (This is reflexive.) */
pragma[inline]
predicate postDominates(ControlFlowNode dom, ControlFlowNode node) {
  // This predicate is gigantic, so it must be inlined.
  bbStrictlyPostDominates(dom.getBasicBlock(), node.getBasicBlock())
  or
  exists(BasicBlock b, int i, int j | dom = b.getNode(i) and node = b.getNode(j) and i >= j)
}
