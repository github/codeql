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
 * Successor relation that includes unreachable AST nodes.
 */
predicate succFull(AstNode a, AstNode b) {
  exists(ControlFlowGraphImpl::ControlFlowTree cft | cft.succ(a, b, _))
}

/**
 * Gets a node we'd prefer not to report as unreachable.
 */
predicate skipNode(AstNode n) {
  // isolated node (not intended to be part of the CFG)
  not succFull(n, _) and
  not succFull(_, n)
  or
  n instanceof ControlFlowGraphImpl::PostOrderTree // location is counter-intuitive
}

/**
 * Successor relation for edges out of `skipNode`s.
 */
predicate succSkip(AstNode a, AstNode b) {
  skipNode(a) and
  succFull(a, b)
}

/**
 * Successor relation that skips over `skipNode`s.
 */
predicate succSkipping(AstNode a, AstNode b) {
  exists(AstNode mid |
    not skipNode(a) and
    succFull(a, mid) and
    succSkip*(mid, b) and
    not skipNode(b)
  )
}

/**
 * An AST node that is reachable.
 */
predicate reachable(AstNode n) { n = any(CfgNode cfn).getAstNode() }

/**
 * Holds if `n` is an AST node that's unreachable, and any predecessors
 * of it are reachable (to avoid duplicate results).
 */
private predicate firstUnreachable(AstNode n) {
  not reachable(n) and
  not skipNode(n) and
  forall(AstNode pred | succSkipping(pred, n) | reachable(pred))
}

from AstNode n
where
  firstUnreachable(n) and
  exists(n.getFile().getRelativePath()) // in source
select n, "This code is never reached."
