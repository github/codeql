private import codeql.swift.elements.expr.MethodLookupExpr
private import codeql.swift.elements.decl.ConstructorDecl

class InitializerLookupExpr extends MethodLookupExpr {
  InitializerLookupExpr() { super.getMethod() instanceof ConstructorDecl }

  override ConstructorDecl getMethod() { result = super.getMethod() }

  override string toString() { result = this.getMember().toString() }
}
