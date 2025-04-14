private import codeql.swift.generated.expr.DynamicSubscriptExpr

module Impl {
  class DynamicSubscriptExpr extends Generated::DynamicSubscriptExpr {
    override string toStringImpl() { result = this.getMember().toStringImpl() + "[...]" }
  }
}
