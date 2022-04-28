/**
 * @kind graph
 */

import codeql.ruby.ast.internal.TreeSitter::Ruby

/**
 * Holds if `node` belongs to the output tree, and its property `key` has the
 * given `value`.
 */
query predicate nodes(AstNode node, string key, string value) {
  key = "semmle.label" and
  value = "[" + node.getPrimaryQlClasses() + "] " + node.toString()
}

/**
 * Holds if `target` is a child of `source` in the AST, and property `key` of
 * the edge has the given `value`.
 */
query predicate edges(AstNode source, AstNode target, string key, string value) {
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
