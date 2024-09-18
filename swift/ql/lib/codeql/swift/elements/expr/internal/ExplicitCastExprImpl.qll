private import codeql.swift.generated.expr.ExplicitCastExpr

module Impl {
  class ExplicitCastExpr extends Generated::ExplicitCastExpr {
    override predicate convertsFrom(Expr e) { e = this.getImmediateSubExpr() }

    override string toString() { result = "(" + this.getType() + ") ..." }
  }
}
