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
  cls = getAPrimaryQlClass(parent) and
  exists(AstNode one, AstNode two |
    one = node.getParent() and
    two = node.getParent() and
    one != two
  |
    one.isSynthesized() and two.isSynthesized()
    or
    not one.isSynthesized() and not two.isSynthesized()
  )
}
