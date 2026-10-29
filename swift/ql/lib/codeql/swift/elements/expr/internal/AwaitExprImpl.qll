private import codeql.swift.generated.expr.AwaitExpr

module Impl {
  class AwaitExpr extends Generated::AwaitExpr {
    override string toStringImpl() { result = "await ..." }
  }
}
