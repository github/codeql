/**
 * @name Debug static name-binding graph
 * @description Renders the graph used to perform static name lookups
 * @kind graph
 * @id unified/debug-static-name-binding-graph
 */

private import unified
private import codeql.unified.internal.StaticNameBinding

/**
 * Holds if `node` should be shown in the graph.
 */
predicate relevantNode(AstNode node) {
  // Match an ancestor node by location so its whole subtree is shown.
  node.getParent*().getLocation().toString().matches("%test.swift@13:%")
}

import DebugGraph<relevantNode/1>
