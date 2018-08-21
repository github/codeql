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


/*
 * In rare cases, the same node is used in multiple control-flow scopes. This
 * confuses the dominance analysis, so this predicate is used to exclude them.
 */
private predicate
hasMultiScopeNode(Function f) {
  exists (ControlFlowNode node |
    node.getControlFlowScope() = f
    and node.getControlFlowScope() != f)
}

/** Holds if `entry` is the entry point of a function. */
predicate functionEntry(ControlFlowNode entry) {
  exists (Function function |
    function.getEntryPoint() = entry
    and not hasMultiScopeNode(function))
}

/** Holds if `entry` is the entry point of a function. */
predicate functionEntryBB(@cfgnode entry) {
  functionEntry(mkElement(entry))
}

/**
 * Holds if `dest` is an immediate successor of `src` in the control-flow graph.
 */
private predicate nodeSucc(ControlFlowNode src, ControlFlowNode dest) {
  src.getASuccessor() = dest
}

/**
 * Holds if `dominator` is an immediate dominator of `node` in the control-flow
 * graph.
 */
predicate iDominates(ControlFlowNode dominator, ControlFlowNode node) = idominance(functionEntry/1,nodeSucc/2)(_, dominator, node)

/**
 * Holds if `dominator` is a strict dominator of `node` in the control-flow
 * graph. Being strict means that `dominator != node`.
 */
predicate strictlyDominates(ControlFlowNode dominator, ControlFlowNode node) {
  iDominates+(dominator, node)
}

/**
 * Holds if `dominator` is a dominator of `node` in the control-flow graph. This
 * is reflexive.
 */
predicate dominates(ControlFlowNode dominator, ControlFlowNode node) {
  strictlyDominates(dominator, node) or dominator = node
}

/*
 * Dominance predicates for basic blocks.
 */

/**
 * Holds if `dominator` is an immediate dominator of `node` in the control-flow
 * graph of basic blocks.
 */
predicate bbIDominates(BasicBlock dom, BasicBlock node) = idominance(functionEntryBB/1, bb_successor/2)(_, dom, node)

/**
 * Holds if `dominator` is a strict dominator of `node` in the control-flow
 * graph of basic blocks. Being strict means that `dominator != node`.
 */
predicate bbStrictlyDominates(BasicBlock dominator, BasicBlock node) {
  bbIDominates+(dominator, node)
}


/**
 * Holds if `dominator` is a dominator of `node` in the control-flow graph of
 * basic blocks. This is reflexive.
 */
predicate bbDominates(BasicBlock dominator, BasicBlock node) {
  bbStrictlyDominates(dominator, node) or dominator = node
}
