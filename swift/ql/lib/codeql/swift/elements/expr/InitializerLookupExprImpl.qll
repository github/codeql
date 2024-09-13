private import codeql.swift.elements.expr.MethodLookupExpr
private import codeql.swift.elements.decl.Initializer

class InitializerLookupExpr extends MethodLookupExpr {
  InitializerLookupExpr() { super.getMethod() instanceof Initializer }

  override Initializer getMethod() { result = super.getMethod() }

  override string toString() { result = this.getMember().toString() }
}
