private import codeql.swift.generated.expr.ForceTryExpr

module Impl {
  class ForceTryExpr extends Generated::ForceTryExpr {
    override string toString() { result = "try! ..." }
  }
}
