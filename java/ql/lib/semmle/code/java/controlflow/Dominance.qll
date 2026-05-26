/**
 * Provides classes and predicates for control-flow graph dominance.
 */
overlay[local?]
module;

import java

/*
 * Predicates for basic-block-level dominance.
 */

/**
 * The dominance frontier relation for basic blocks.
 *
 * This is equivalent to:
 *
 * ```
 *   x.dominates(w.getAPredecessor()) and not x.strictlyDominates(w)
 * ```
 */
predicate dominanceFrontier(BasicBlock x, BasicBlock w) {
  x = w.getAPredecessor() and not x.immediatelyDominates(w)
  or
  exists(BasicBlock prev | dominanceFrontier(prev, w) |
    x.immediatelyDominates(prev) and
    not x.immediatelyDominates(w)
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
    dom.immediatelyDominates(bb) and
    dominator = dom.getLastNode() and
    node = bb.getFirstNode()
  )
}

/** Holds if `dom` strictly dominates `node`. */
overlay[caller?]
pragma[inline]
predicate strictlyDominates(ControlFlowNode dom, ControlFlowNode node) {
  // This predicate is gigantic, so it must be inlined.
  dom.getBasicBlock().strictlyDominates(node.getBasicBlock())
  or
  exists(BasicBlock b, int i, int j | dom = b.getNode(i) and node = b.getNode(j) and i < j)
}

/** Holds if `dom` dominates `node`. (This is reflexive.) */
overlay[caller?]
pragma[inline]
predicate dominates(ControlFlowNode dom, ControlFlowNode node) {
  // This predicate is gigantic, so it must be inlined.
  dom.getBasicBlock().strictlyDominates(node.getBasicBlock())
  or
  exists(BasicBlock b, int i, int j | dom = b.getNode(i) and node = b.getNode(j) and i <= j)
}

/** Holds if `dom` strictly post-dominates `node`. */
overlay[caller?]
pragma[inline]
predicate strictlyPostDominates(ControlFlowNode dom, ControlFlowNode node) {
  // This predicate is gigantic, so it must be inlined.
  dom.getBasicBlock().strictlyPostDominates(node.getBasicBlock())
  or
  exists(BasicBlock b, int i, int j | dom = b.getNode(i) and node = b.getNode(j) and i > j)
}

/** Holds if `dom` post-dominates `node`. (This is reflexive.) */
overlay[caller?]
pragma[inline]
predicate postDominates(ControlFlowNode dom, ControlFlowNode node) {
  // This predicate is gigantic, so it must be inlined.
  dom.getBasicBlock().strictlyPostDominates(node.getBasicBlock())
  or
  exists(BasicBlock b, int i, int j | dom = b.getNode(i) and node = b.getNode(j) and i >= j)
}
