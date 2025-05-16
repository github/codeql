/**
 * Provides classes and predicates for control-flow graph dominance.
 */

import java

/*
 * Predicates for basic-block-level dominance.
 */

/** The immediate dominance relation for basic blocks. */
predicate bbIDominates(BasicBlock dom, BasicBlock node) { dom.immediatelyDominates(node) }

/** Exit points for basic-block control-flow. */
private predicate bbSink(BasicBlock exit) { exit.getLastNode() instanceof ControlFlow::ExitNode }

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
