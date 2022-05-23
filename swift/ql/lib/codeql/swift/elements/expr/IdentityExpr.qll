private import codeql.swift.generated.expr.IdentityExpr

class IdentityExpr extends IdentityExprBase {
  override predicate convertsFrom(Expr e) { identity_exprs(this, e) }
}
