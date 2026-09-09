/**
 * @name Debug local name-binding graph
 * @description Renders the graph used to perform local name lookups
 * @kind graph
 * @id unified/debug-local-name-binding-graph
 */

private import unified
private import codeql.unified.internal.LocalNameBinding

/**
 * Holds if `node` should be shown in the graph.
 */
predicate relevantNode(AstNode node) {
  // Match an ancestor node by location so its whole subtree is shown.
  node.getParent*().getLocation().toString().matches("%test.swift@227:%")
}

import LocalNameBindingOutput::DebugScopeGraph<relevantNode/1>
