private import codeql.swift.generated.AstNode
private import codeql.swift.elements.decl.AbstractFunctionDecl
private import codeql.swift.elements.decl.Decl
private import codeql.swift.generated.ParentChild

private module Cached {
  private Element getEnclosingDeclStep(Element e) {
    not e instanceof Decl and
    result = getImmediateParent(e)
  }

  cached
  Decl getEnclosingDecl(AstNode ast) { result = getEnclosingDeclStep*(getImmediateParent(ast)) }

  private Element getEnclosingFunctionStep(Element e) {
    not e instanceof AbstractFunctionDecl and
    result = getEnclosingDecl(e)
  }

  cached
  AbstractFunctionDecl getEnclosingFunction(AstNode ast) {
    result = getEnclosingFunctionStep*(getEnclosingDecl(ast))
  }
}

class AstNode extends Generated::AstNode {
  final AbstractFunctionDecl getEnclosingFunction() { result = Cached::getEnclosingFunction(this) }

  final Decl getEnclosingDecl() { result = Cached::getEnclosingDecl(this) }
}
