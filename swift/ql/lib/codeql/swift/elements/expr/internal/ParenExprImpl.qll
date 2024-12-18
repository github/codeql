private import codeql.swift.generated.expr.ParenExpr

module Impl {
  class ParenExpr extends Generated::ParenExpr {
    override string toString() { result = "(...)" }
  }
}
