private import codeql.swift.elements.expr.MethodLookupExpr
private import codeql.swift.elements.expr.internal.MethodLookupExprImpl::Impl as Impl
private import codeql.swift.elements.decl.Initializer

final private class InitializerLookupExprImpl extends Impl::MethodLookupExpr {
  InitializerLookupExprImpl() { super.getMethod() instanceof Initializer }

  override string toString() { result = this.getMember().toString() }
}

final class InitializerLookupExpr extends MethodLookupExpr, InitializerLookupExprImpl {
  Initializer getMethod() { result = super.getMethod() }
}
