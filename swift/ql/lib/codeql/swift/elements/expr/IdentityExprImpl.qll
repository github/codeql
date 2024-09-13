private import codeql.swift.generated.expr.IdentityExpr

class IdentityExpr extends Generated::IdentityExpr {
  override predicate convertsFrom(Expr e) { e = this.getImmediateSubExpr() }
}
