private import codeql.swift.generated.expr.DynamicSubscriptExpr

module Impl {
  class DynamicSubscriptExpr extends Generated::DynamicSubscriptExpr {
    override string toString() { result = this.getMember().toString() + "[...]" }
  }
}
