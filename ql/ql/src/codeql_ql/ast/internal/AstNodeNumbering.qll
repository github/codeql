private import codeql_ql.ast.Ast

pragma[inline]
private predicate isNumberedNode(AstNode node) {
  // these are not nested in the location of the parent node, so we can't use their location to order them
  not node instanceof Annotation and
  not node instanceof QLDoc
}

private int getNodeDepth(AstNode node) {
  node instanceof TopLevel and
  result = 0
  or
  isNumberedNode(node) and
  result = 1 + getNodeDepth(node.getParent())
}

/**
 * Gets the pre-order ID for the given `node`, that is, its visit position
 * in a pre-order traversal of all nodes.
 *
 * The children of a node are ordered left-to-right as they appear in the source code.
 *
 * The ID is globally unique for this AST node, also across files.
 *
 * At the moment this predicate is only defined for node which are:
 * - reachable via `getAChild` edges from a `TopLevel`, and
 * - is not a comment or annotation
 */
cached
int getPreOrderId(AstNode node) {
  node =
    rank[result](AstNode n, Location loc, int depth |
      depth = getNodeDepth(n) and loc = n.getLocation()
    |
      n order by loc.getFile().getAbsolutePath(), loc.getStartLine(), loc.getStartColumn(), depth
    )
}
