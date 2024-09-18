private import codeql.swift.generated.expr.UnresolvedDotExpr

module Impl {
  class UnresolvedDotExpr extends Generated::UnresolvedDotExpr {
    override string toString() { result = "... ." + this.getName() }
  }
}
