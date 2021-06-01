/**
 * Provides queries to pretty-print a Ruby abstract syntax tree as a graph.
 *
 * By default, this will print the AST for all nodes in the database. To change
 * this behavior, extend `PrintASTConfiguration` and override `shouldPrintNode`
 * to hold for only the AST nodes you wish to view.
 */

import AST

/** Holds if `n` appears in the desugaring of some other node. */
predicate isDesugared(AstNode n) {
  n = any(AstNode sugar).getDesugared()
  or
  isDesugared(n.getParent())
}

/**
 * The query can extend this class to control which nodes are printed.
 */
class PrintAstConfiguration extends string {
  PrintAstConfiguration() { this = "PrintAstConfiguration" }

  /**
   * Holds if the given node should be printed.
   */
  predicate shouldPrintNode(AstNode n) {
    not isDesugared(n)
    or
    not n.isSynthesized()
    or
    n.isSynthesized() and
    not n = any(AstNode sugar).getDesugared() and
    exists(AstNode parent |
      parent = n.getParent() and
      not parent.isSynthesized() and
      not n = parent.getDesugared()
    )
  }

  predicate shouldPrintEdge(AstNode parent, string edgeName, AstNode child) {
    child = parent.getAChild(edgeName) and
    not child = parent.getDesugared()
  }
}

/**
 * A node in the output tree.
 */
class PrintAstNode extends AstNode {
  PrintAstNode() { shouldPrintNode(this) }

  string getProperty(string key) {
    key = "semmle.label" and
    result = "[" + concat(this.getAPrimaryQlClass(), ", ") + "] " + this.toString()
    or
    key = "semmle.order" and
    result =
      any(int i |
        this =
          rank[i](PrintAstNode p, Location l, File f |
            l = p.getLocation() and
            f = l.getFile()
          |
            p order by f.getBaseName(), f.getAbsolutePath(), l.getStartLine(), l.getStartColumn()
          )
      ).toString()
  }

  /**
   * Gets the child node that is accessed using the predicate `edgeName`.
   */
  PrintAstNode getChild(string edgeName) { shouldPrintEdge(this, edgeName, result) }
}

private predicate shouldPrintNode(AstNode n) {
  any(PrintAstConfiguration config).shouldPrintNode(n)
}

private predicate shouldPrintEdge(PrintAstNode parent, string edgeName, PrintAstNode child) {
  any(PrintAstConfiguration config).shouldPrintEdge(parent, edgeName, child)
}

/**
 * Holds if `node` belongs to the output tree, and its property `key` has the
 * given `value`.
 */
query predicate nodes(PrintAstNode node, string key, string value) { value = node.getProperty(key) }

/**
 * Holds if `target` is a child of `source` in the AST, and property `key` of
 * the edge has the given `value`.
 */
query predicate edges(PrintAstNode source, PrintAstNode target, string key, string value) {
  target = source.getChild(_) and
  (
    key = "semmle.label" and
    value = strictconcat(string name | source.getChild(name) = target | name, "/")
    or
    key = "semmle.order" and
    value = target.getProperty("semmle.order")
  )
}

/**
 * Holds if property `key` of the graph has the given `value`.
 */
query predicate graphProperties(string key, string value) {
  key = "semmle.graphKind" and value = "tree"
}
