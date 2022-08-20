private import codeql.swift.generated.AstNode
private import codeql.swift.elements.decl.AbstractFunctionDecl
private import codeql.swift.generated.GetImmediateParent

private Element getEnclosingFunctionStep(Element e) {
  not e instanceof AbstractFunctionDecl and
  result = getImmediateParent(e)
}

cached
private AbstractFunctionDecl getEnclosingFunctionCached(AstNode ast) {
  result = getEnclosingFunctionStep*(getImmediateParent(ast))
}

class AstNode extends AstNodeBase {
  final AbstractFunctionDecl getEnclosingFunction() { result = getEnclosingFunctionCached(this) }
}
