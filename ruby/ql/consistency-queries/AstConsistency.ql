import codeql.ruby.AST
import codeql.ruby.ast.internal.Synthesis
import codeql.ruby.Diagnostics

query predicate missingParent(AstNode node, string cls) {
  not exists(node.getParent()) and
  node.getLocation().getFile().getExtension() != "erb" and
  not node instanceof Toplevel and
  cls = node.getPrimaryQlClasses()
}

pragma[noinline]
private AstNode parent(AstNode child, int desugarLevel) {
  result = child.getParent() and
  desugarLevel = desugarLevel(result)
}

query predicate multipleParents(AstNode node, AstNode parent, string cls) {
  parent = node.getParent() and
  cls = parent.getPrimaryQlClasses() and
  exists(AstNode one, AstNode two, int desugarLevel |
    one = parent(node, desugarLevel) and
    two = parent(node, desugarLevel) and
    one != two
  )
}

query predicate multipleToString(AstNode n, string s) {
  s = strictconcat(n.toString(), ",") and
  strictcount(n.toString()) > 1
}

query predicate extractionError(ExtractionError error) { any() }

query predicate extractionWarning(ExtractionWarning error) { any() }
