import codeql_ruby.AST

private string getAPrimaryQlClass(AstNode node) {
  result = node.getAPrimaryQlClass()
  or
  not exists(node.getAPrimaryQlClass()) and result = "(none)"
}

query predicate missingParent(AstNode node, string cls) {
  not exists(node.getParent()) and
  node.getLocation().getFile().getExtension() != "erb" and
  not node instanceof Toplevel and
  cls = getAPrimaryQlClass(node)
}

query predicate multipleParents(AstNode node, AstNode parent, string cls) {
  parent = node.getParent() and
  count(node.getParent()) > 1 and
  cls = getAPrimaryQlClass(parent)
}
