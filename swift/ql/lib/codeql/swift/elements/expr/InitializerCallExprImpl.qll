private import codeql.swift.elements.expr.MethodCallExpr
private import codeql.swift.elements.expr.InitializerLookupExpr
private import codeql.swift.elements.decl.Initializer

class InitializerCallExpr extends MethodCallExpr {
  InitializerCallExpr() { this.getFunction() instanceof InitializerLookupExpr }

  override Initializer getStaticTarget() { result = super.getStaticTarget() }
}
