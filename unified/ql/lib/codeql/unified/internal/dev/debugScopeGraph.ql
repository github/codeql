/**
 * @name Debug scope graph
 * @description Renders the graph used to perform local variable lookups
 * @kind graph
 * @id unified/debug-scope-graph
 */

private import unified
private import codeql.unified.internal.Variables

/**
 * Holds if `node` should be shown in the graph.
 */
predicate relevantNode(AstNode node) {
  // Match an ancestor node by location so its whole subtree is shown.
  node.getParent*().getLocation().toString().matches("%test.swift@227:%")
}

import LocalNameBindingOutput::DebugScopeGraph<relevantNode/1>
