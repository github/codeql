private import codeql.swift.elements.expr.MethodCallExpr
private import codeql.swift.elements.expr.InitializerLookupExpr
private import codeql.swift.elements.decl.Initializer

final class InitializerCallExpr extends MethodCallExpr {
  InitializerCallExpr() { this.getFunction() instanceof InitializerLookupExpr }

  Initializer getStaticTarget() { result = super.getStaticTarget() }
}
