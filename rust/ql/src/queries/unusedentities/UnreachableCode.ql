/**
 * @name Unreachable code
 * @description Code that cannot be reached should be deleted.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id rust/dead-code
 * @tags maintainability
 */

import rust
import codeql.rust.controlflow.ControlFlowGraph
import codeql.rust.controlflow.internal.ControlFlowGraphImpl as ControlFlowGraphImpl

/**
 * Holds if `n` is an AST node that's unreachable, and is not the successor
 * of an unreachable node (which would be a duplicate result).
 */
predicate firstUnreachable(AstNode n) {
  // entry nodes are reachable
  not exists(CfgScope s | s.scopeFirst(n)) and
  // we never want a `ControlFlowTree` successor node:
  //  - if the predecessor is reachable, so are we.
  //  - if the predecessor is unreachable, we're not the *first* unreachable node.
  not ControlFlowGraphImpl::succ(_, n, _)
  // (note that an unreachable cycle of nodes could be missed by this logic, in
  //  general it wouldn't be possible to pick one node to represent it)
}

/**
 * Gets a node we'd prefer not to report as unreachable.
 */
predicate skipNode(AstNode n) {
  n instanceof ControlFlowGraphImpl::PostOrderTree or // location is counter-intuitive
  not n instanceof ControlFlowGraphImpl::ControlFlowTree // not expected to be reachable
}

/**
 * Gets the `ControlFlowTree` successor of a node we'd prefer not to report.
 */
AstNode skipSuccessor(AstNode n) {
  skipNode(n) and
  ControlFlowGraphImpl::succ(n, result, _)
}

/**
 * Gets the node `n`, skipping past any nodes we'd prefer not to report.
 */
AstNode skipSuccessors(AstNode n) {
  result = skipSuccessor*(n) and
  not skipNode(result)
}

from AstNode first, AstNode report
where
  firstUnreachable(first) and
  report = skipSuccessors(first) and
  exists(report.getFile().getRelativePath()) // in source
select report, "This code is never reached."
