private import codeql.swift.generated.expr.TryExpr

module Impl {
  class TryExpr extends Generated::TryExpr {
    override string toString() { result = "try ..." }
  }
}
