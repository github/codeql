/**
 * INTERNAL. DO NOT IMPORT DIRECTLY.
 *
 * Provides predicates and classes for relating nodes to their
 * enclosing `StmtContainer`.
 */

private import javascript
private import semmle.javascript.internal.CachedStages

cached
private StmtContainer getStmtContainer(NodeInStmtContainer node) {
  Stages::Ast::ref() and
  expr_containers(node, result)
  or
  stmt_containers(node, result)
  or
  // Properties
  exists(AstNode parent | properties(node, parent, _, _, _) |
    expr_containers(parent, result)
    or
    stmt_containers(parent, result)
  )
  or
  // Synthetic CFG nodes
  entry_cfg_node(node, result)
  or
  exit_cfg_node(node, result)
  or
  exists(Expr test |
    guard_node(node, _, test) and
    expr_containers(test, result)
  )
  or
  // JSDoc type annotations
  stmt_containers(node.(JSDocTypeExpr).getEnclosingStmt(), result)
}

/**
 * A node that occurs inside a function or top-level or is itself a top-level.
 *
 * Specifically, this is the union type of `ControlFlowNode`, `TypeAnnotation`,
 * and `TopLevel`.
 */
class NodeInStmtContainer extends Locatable, @node_in_stmt_container {
  /**
   * Gets the function or toplevel to which this node belongs.
   */
  pragma[inline]
  final StmtContainer getContainer() { result = getStmtContainer(this) }
}
