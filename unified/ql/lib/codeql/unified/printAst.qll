/** Provides a configurable query for printing AST nodes */

private import unified

/**
 * The query can extend this class to control which nodes are printed.
 */
class PrintAstConfiguration extends string {
  PrintAstConfiguration() { this = "PrintAstConfiguration" }

  /**
   * Holds if the given node should be printed.
   */
  predicate shouldPrintNode(AstNode n) { not n instanceof TriviaToken }

  /**
   * Holds if the given edge should be printed.
   */
  predicate shouldPrintAstEdge(AstNode parent, string edgeName, AstNode child) {
    exists(string name, int i |
      child = PrintAst::getChild(parent, name, i) and
      (if i = -1 then edgeName = name else edgeName = name + "(" + i + ")")
    )
  }
}

private predicate shouldPrintNode(AstNode n) {
  any(PrintAstConfiguration config).shouldPrintNode(n)
}

private predicate shouldPrintAstEdge(AstNode parent, string edgeName, AstNode child) {
  any(PrintAstConfiguration config).shouldPrintAstEdge(parent, edgeName, child) and
  shouldPrintNode(parent) and
  shouldPrintNode(child)
}

/**
 * Get an alias for the predicate `name` to use for ordering purposes, to control where
 * in the list of children it should appear.
 */
private string reorderName1(string name) { name = "getModifier" and result = "00_getModifier" }

bindingset[name]
private string reorderName(string name) {
  result = reorderName1(name)
  or
  not exists(reorderName1(name)) and
  result = name
}

class PrintAstNode extends AstNode {
  final int getOrder() {
    this =
      rank[result](AstNode parent, AstNode child, string name, int i |
        child = PrintAst::getChild(parent, name, i)
      |
        child order by reorderName(name), i
      )
  }

  final string getProperty(string key) {
    key = "semmle.label" and
    result = this.toString()
    or
    key = "semmle.order" and result = this.getOrder().toString()
  }
}

/**
 * Holds if `node` belongs to the output tree, and its property `key` has the
 * given `value`.
 */
query predicate nodes(PrintAstNode node, string key, string value) {
  shouldPrintNode(node) and
  value = node.getProperty(key)
}

/**
 * Holds if `target` is a child of `source` in the AST, and property `key` of
 * the edge has the given `value`.
 */
query predicate edges(PrintAstNode source, PrintAstNode target, string key, string value) {
  key = "semmle.label" and
  shouldPrintAstEdge(source, value, target)
  or
  key = "semmle.order" and
  shouldPrintAstEdge(source, _, target) and
  value = target.getProperty("semmle.order")
}

/**
 * Holds if property `key` of the graph has the given `value`.
 */
query predicate graphProperties(string key, string value) {
  key = "semmle.graphKind" and value = "tree"
}
