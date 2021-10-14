/**
 * Provides dominance predicates for control-flow nodes.
 *
 * These variations of the _dominance relation_ are used for computing SSA
 * form. Formally, a node `d` _dominates_ a node `n` if all paths from the
 * function entry point to `n` go through `d`; this applies within a function
 * and only for nodes reachable from the entry point. Unreachable nodes are not
 * part the dominance relation.
 */

import cpp

/**
 * In rare cases, the same node is used in multiple control-flow scopes. This
 * confuses the dominance analysis, so this predicate is used to exclude them.
 */
pragma[noinline]
private predicate hasMultiScopeNode(Function f) {
  exists(ControlFlowNode node |
    node.getControlFlowScope() = f and
    node.getControlFlowScope() != f
  )
}

/** Holds if `entry` is the entry point of a function. */
predicate functionEntry(ControlFlowNode entry) {
  exists(Function function |
    function.getEntryPoint() = entry and
    not hasMultiScopeNode(function)
  )
}

/** Holds if `exit` is the exit node of a function. */
predicate functionExit(ControlFlowNode exit) {
  exists(Function function |
    function = exit and
    not hasMultiScopeNode(function)
  )
}

/**
 * Holds if `dest` is an immediate successor of `src` in the control-flow graph.
 */
private predicate nodeSucc(ControlFlowNode src, ControlFlowNode dest) { src.getASuccessor() = dest }

/**
 * Holds if `pred` is an immediate predecessor of `src` in the control-flow graph.
 */
private predicate nodePred(ControlFlowNode src, ControlFlowNode pred) {
  src.getAPredecessor() = pred
}

/**
 * Holds if `dominator` is an immediate dominator of `node` in the control-flow
 * graph.
 */
predicate iDominates(ControlFlowNode dominator, ControlFlowNode node) =
  idominance(functionEntry/1, nodeSucc/2)(_, dominator, node)

/**
 * Holds if `postDominator` is an immediate post-dominator of `node` in the control-flow
 * graph.
 */
predicate iPostDominates(ControlFlowNode postDominator, ControlFlowNode node) =
  idominance(functionExit/1, nodePred/2)(_, postDominator, node)

/**
 * Holds if `dominator` is a strict dominator of `node` in the control-flow
 * graph. Being strict means that `dominator != node`.
 */
predicate strictlyDominates(ControlFlowNode dominator, ControlFlowNode node) {
  iDominates+(dominator, node)
}

/**
 * Holds if `postDominator` is a strict post-dominator of `node` in the control-flow
 * graph. Being strict means that `postDominator != node`.
 */
predicate strictlyPostDominates(ControlFlowNode postDominator, ControlFlowNode node) {
  iPostDominates+(postDominator, node)
}

/**
 * Holds if `dominator` is a dominator of `node` in the control-flow graph. This
 * is reflexive.
 */
predicate dominates(ControlFlowNode dominator, ControlFlowNode node) {
  strictlyDominates(dominator, node) or dominator = node
}

/**
 * Holds if `postDominator` is a post-dominator of `node` in the control-flow graph. This
 * is reflexive.
 */
predicate postDominates(ControlFlowNode postDominator, ControlFlowNode node) {
  strictlyPostDominates(postDominator, node) or postDominator = node
}

/*
 * Dominance predicates for basic blocks.
 */

/**
 * Holds if `dominator` is an immediate dominator of `node` in the control-flow
 * graph of basic blocks.
 */
predicate bbIDominates(BasicBlock dom, BasicBlock node) =
  idominance(functionEntry/1, bb_successor/2)(_, dom, node)

/**
 * Holds if `pred` is a predecessor of `succ` in the control-flow graph of
 * basic blocks.
 */
private predicate bb_predecessor(BasicBlock succ, BasicBlock pred) { bb_successor(pred, succ) }

/** Holds if `exit` is an `ExitBasicBlock`. */
private predicate bb_exit(ExitBasicBlock exit) { any() }

/**
 * Holds if `postDominator` is an immediate post-dominator of `node` in the control-flow
 * graph of basic blocks.
 */
predicate bbIPostDominates(BasicBlock pDom, BasicBlock node) =
  idominance(bb_exit/1, bb_predecessor/2)(_, pDom, node)

/**
 * Holds if `dominator` is a strict dominator of `node` in the control-flow
 * graph of basic blocks. Being strict means that `dominator != node`.
 */
// magic prevents fastTC
pragma[nomagic]
predicate bbStrictlyDominates(BasicBlock dominator, BasicBlock node) {
  bbIDominates+(dominator, node)
}

/**
 * Holds if `postDominator` is a strict post-dominator of `node` in the control-flow
 * graph of basic blocks. Being strict means that `postDominator != node`.
 */
// magic prevents fastTC
pragma[nomagic]
predicate bbStrictlyPostDominates(BasicBlock postDominator, BasicBlock node) {
  bbIPostDominates+(postDominator, node)
}

/**
 * Holds if `dominator` is a dominator of `node` in the control-flow graph of
 * basic blocks. This is reflexive.
 */
predicate bbDominates(BasicBlock dominator, BasicBlock node) {
  bbStrictlyDominates(dominator, node) or dominator = node
}

/**
 * Holds if `postDominator` is a post-dominator of `node` in the control-flow graph of
 * basic blocks. This is reflexive.
 */
predicate bbPostDominates(BasicBlock postDominator, BasicBlock node) {
  bbStrictlyPostDominates(postDominator, node) or postDominator = node
}
