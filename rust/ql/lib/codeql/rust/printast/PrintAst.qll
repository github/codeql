/**
 * Provides queries to pretty-print a Rust AST as a graph.
 */

import codeql.rust.printast.PrintAstNode

module PrintAst<shouldPrintSig/1 shouldPrint> {
  import PrintAstNode<shouldPrint/1>

  pragma[nomagic]
  private predicate orderBy(
    PrintAstNode n, string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    n.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  private int getOrder(PrintAstNode node) {
    node =
      rank[result](PrintAstNode n, string filepath, int startline, int startcolumn, int endline,
        int endcolumn |
        orderBy(n, filepath, startline, startcolumn, endline, endcolumn)
      |
        n order by filepath, startline, startcolumn, endline, endcolumn
      )
  }

  /** Holds if `node` belongs to the output tree, and its property `key` has the given `value`. */
  query predicate nodes(PrintAstNode node, string key, string value) {
    key = "semmle.label" and value = node.toString()
    or
    key = "semmle.order" and value = getOrder(node).toString()
    or
    value = node.getProperty(key)
  }

  /**
   * Holds if `target` is a child of `source` in the AST, and property `key` of the edge has the
   * given `value`.
   */
  query predicate edges(PrintAstNode source, PrintAstNode target, string key, string value) {
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
}
