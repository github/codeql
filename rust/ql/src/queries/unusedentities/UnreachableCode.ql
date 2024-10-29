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
private predicate succ(AstNode a, AstNode b) {
  exists(ControlFlowGraphImpl::ControlFlowTree cft | cft.succ(a, b, _))
}

/**
 * Gets a node we'd prefer not to report as unreachable. These will be removed
 * from the AST for the purposes of this query, with successor links being
 * made across them where appropriate.
 */
predicate hiddenNode(AstNode n) {
  // isolated node (not intended to be part of the CFG)
  not succ(n, _) and
  not succ(_, n)
  or
  n instanceof ControlFlowGraphImpl::PostOrderTree and // location is counter-intuitive
  not n instanceof MacroExpr
  or
  n.isInMacroExpansion()
}

/**
 * Successor relation for edges out of `hiddenNode`s.
 */
private predicate succHidden(AstNode a, AstNode b) {
  hiddenNode(a) and
  succ(a, b)
}

/**
 * Successor relation that removes / links over `hiddenNode`s.
 */
private predicate succWithHiding(AstNode a, AstNode b) {
  exists(AstNode mid |
    not hiddenNode(a) and
    succ(a, mid) and
    succHidden*(mid, b) and
    not hiddenNode(b)
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
  not hiddenNode(n) and
  forall(AstNode pred | succWithHiding(pred, n) | reachable(pred))
}

from AstNode n
where
  firstUnreachable(n) and
  exists(n.getFile().getRelativePath()) // in source
select n, "This code is never reached."
