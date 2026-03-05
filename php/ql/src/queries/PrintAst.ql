/**
 * @name Print AST
 * @description Outputs a representation of a file's Abstract Syntax Tree.
 * @id php/print-ast
 * @kind graph
 */

import codeql.php.AST

private predicate shouldPrint(AstNode node) { any() }

private predicate orderBy(
  AstNode n, string filepath, int startline, int startcolumn, int endline, int endcolumn
) {
  shouldPrint(n) and
  n.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
}

private int getOrder(AstNode node) {
  node =
    rank[result](AstNode n, string filepath, int startline, int startcolumn, int endline,
      int endcolumn |
      orderBy(n, filepath, startline, startcolumn, endline, endcolumn)
    |
      n order by filepath, startline, startcolumn, endline, endcolumn
    )
}

query predicate nodes(AstNode node, string key, string value) {
  shouldPrint(node) and
  (
    key = "semmle.label" and
    value = "[" + node.getPrimaryQlClasses() + "] " + node.toString()
    or
    key = "semmle.order" and value = getOrder(node).toString()
  )
}

query predicate edges(AstNode source, AstNode target, string key, string value) {
  shouldPrint(source) and
  shouldPrint(target) and
  exists(int index | target = source.getChild(index) |
    key = "semmle.label" and value = index.toString()
    or
    key = "semmle.order" and value = index.toString()
  )
}

query predicate graphProperties(string key, string value) {
  key = "semmle.graphKind" and value = "tree"
}
