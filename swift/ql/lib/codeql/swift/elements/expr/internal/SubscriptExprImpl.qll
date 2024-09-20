private import codeql.swift.generated.expr.SubscriptExpr

module Impl {
  class SubscriptExpr extends Generated::SubscriptExpr {
    Argument getFirstArgument() {
      exists(int i |
        result = this.getArgument(i) and
        not exists(this.getArgument(i - 1))
      )
    }

    Argument getLastArgument() {
      exists(int i |
        result = this.getArgument(i) and
        not exists(this.getArgument(i + 1))
      )
    }

    override string toString() { result = "...[...]" }
  }
}
