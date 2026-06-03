import codeql.actions.Ast
import codeql.actions.DataFlow
import codeql.actions.MappingHelper

/**
 * Lists all mapping entries found in mapping.yaml files.
 */
query predicate actionMappings(string ownerRepo, string ref, string sha) {
  externalActionRefMapping(ownerRepo, ref, sha)
}

/**
 * Lists all composite actions discovered and their resolved paths.
 */
query predicate compositeActions(CompositeAction ca) { any() }

/**
 * Lists all calls (uses: steps) and their callee names.
 */
query predicate calls(DataFlow::CallNode c) { any() }

/**
 * Lists resolved call targets: for each call node, which callable does it resolve to.
 * This exercises viableCallable through the public CallNode.getCalleeNode() API.
 */
query predicate resolvedCalls(DataFlow::CallNode c, string targetName) {
  targetName = c.getCalleeNode().getName()
}
