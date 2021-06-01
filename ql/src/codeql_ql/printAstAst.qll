/**
 * Provides queries to pretty-print a QL abstract syntax tree as a graph.
 *
 * This representation is based on the user-facing AST implementation.
 *
 * By default, this will print the AST for all nodes in the database. To change
 * this behavior, extend `PrintASTConfiguration` and override `shouldPrintNode`
 * to hold for only the AST nodes you wish to view.
 */

import ast.Ast
private import codeql.Locations

/**
 * The query can extend this class to control which nodes are printed.
 */
class PrintAstConfiguration extends string {
  PrintAstConfiguration() { this = "PrintAstConfiguration" }

  /**
   * Holds if the given node should be printed.
   */
  predicate shouldPrintNode(AstNode n) { any() }
}

/**
 * Gets the `i`th child of parent.
 * The ordering is location based and pretty arbitary.
 */
AstNode getAstChild(PrintAstNode parent, int i) {
  result =
    rank[i](AstNode child, Location l |
      child.getParent() = parent and
      child.getLocation() = l
    |
      child
      order by
        l.getStartLine(), l.getStartColumn(), l.getEndColumn(), l.getEndLine(), child.toString()
    )
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
  PrintAstNode getChild(string edgeName) { result = this.getAChild(edgeName) }
}

private predicate shouldPrintNode(AstNode n) {
  exists(PrintAstConfiguration config | config.shouldPrintNode(n))
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
