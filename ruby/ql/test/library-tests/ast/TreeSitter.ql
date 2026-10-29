/**
 * @kind graph
 */

import codeql.ruby.ast.internal.TreeSitter
import codeql.Locations

/**
 * Holds if `node` belongs to the output tree, and its property `key` has the
 * given `value`.
 */
query predicate nodes(Ruby::AstNode node, string key, string value) {
  key = "semmle.label" and
  value = "[" + node.getPrimaryQlClasses() + "] " + node.toString()
  or
  key = "semmle.order" and
  value =
    any(int i |
      node =
        rank[i](Ruby::AstNode n, Location l |
          l = n.getLocation()
        |
          n
          order by
            l.getFile().getRelativePath(), l.getFile().getAbsolutePath(), l.getStartLine(),
            l.getStartColumn(), l.getEndLine() desc, l.getEndColumn() desc, n.toString()
        )
    ).toString()
}

/**
 * Holds if `target` is a child of `source` in the AST, and property `key` of
 * the edge has the given `value`.
 */
query predicate edges(Ruby::AstNode source, Ruby::AstNode target, string key, string value) {
  source = target.getParent() and
  key = ["semmle.label", "semmle.order"] and
  value = target.getParentIndex().toString()
}

/**
 * Holds if property `key` of the graph has the given `value`.
 */
query predicate graphProperties(string key, string value) {
  key = "semmle.graphKind" and value = "tree"
}
