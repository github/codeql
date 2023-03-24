/**
 * Provides queries to pretty-print a Swift AST as a graph.
 */

import PrintAstNode

cached
private int getOrder(PrintAstNode node) {
  node =
    rank[result](PrintAstNode n, Location loc |
      loc = n.getLocation()
    |
      n
      order by
        loc.getFile().getName(), loc.getStartLine(), loc.getStartColumn(), loc.getEndLine(),
        loc.getEndColumn()
    )
}

/** Holds if `node` belongs to the output tree, and its property `key` has the given `value`. */
query predicate nodes(PrintAstNode node, string key, string value) {
  node.shouldBePrinted() and
  (
    key = "semmle.label" and value = node.toString()
    or
    key = "semmle.order" and value = getOrder(node).toString()
    or
    value = node.getProperty(key)
  )
}

/**
 * Holds if `target` is a child of `source` in the AST, and property `key` of the edge has the
 * given `value`.
 */
query predicate edges(PrintAstNode source, PrintAstNode target, string key, string value) {
  source.shouldBePrinted() and
  target.shouldBePrinted() and
  exists(int index, string accessor | source.hasChild(target, index, accessor) |
    key = "semmle.label" and value = accessor
    or
    key = "semmle.order" and value = index.toString()
  )
}

/** Holds if property `key` of the graph has the given `value`. */
query predicate graphProperties(string key, string value) {
  key = "semmle.graphKind" and value = "tree"
}
