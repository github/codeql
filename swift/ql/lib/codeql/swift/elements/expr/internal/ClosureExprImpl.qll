private import codeql.swift.generated.expr.ClosureExpr

module Impl {
  class ClosureExpr extends Generated::ClosureExpr {
    override string toString() { result = "{ ... }" }
  }
}
