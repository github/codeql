private import codeql.swift.generated.expr.TryExpr

module Impl {
  class TryExpr extends Generated::TryExpr {
    override string toStringImpl() { result = "try ..." }
  }
}
