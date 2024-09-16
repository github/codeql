private import codeql.swift.generated.expr.OneWayExpr

module Impl {
  class OneWayExpr extends Generated::OneWayExpr {
    override predicate convertsFrom(Expr e) { e = this.getImmediateSubExpr() }

    override string toString() { result = this.getSubExpr().toString() }
  }
}
