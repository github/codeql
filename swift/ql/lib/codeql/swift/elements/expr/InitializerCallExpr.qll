private import codeql.swift.elements.expr.MethodCallExpr
private import codeql.swift.elements.expr.InitializerLookupExpr
private import codeql.swift.elements.decl.ConstructorDecl

class InitializerCallExpr extends MethodCallExpr {
  InitializerCallExpr() { this.getFunction() instanceof InitializerLookupExpr }

  override ConstructorDecl getStaticTarget() { result = super.getStaticTarget() }
}
