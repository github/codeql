private import codeql.swift.generated.expr.IdentityExpr

module Impl {
  class IdentityExpr extends Generated::IdentityExpr {
    override predicate convertsFrom(Expr e) { e = this.getImmediateSubExpr() }
  }
}
