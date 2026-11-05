/**
 * @name Debug data flow graph
 * @description Renders the data flow graph
 * @kind graph
 * @id unified/debug-data-flow-graph
 */

private import unified
private import codeql.unified.internal.dataflow.DataFlowGraph

/**
 * Holds if `node` should be shown in the graph.
 */
predicate relevantNode(AstNode node) {
  // Match an ancestor node by location so its whole subtree is shown.
  node.getParent*().getLocation().toString().matches("%test.swift@13:%")
}

import DebugGraph<relevantNode/1>
