private import codeql.swift.generated.expr.IsExpr

module Impl {
  class IsExpr extends Generated::IsExpr {
    override string toString() { result = "... is ..." }
  }
}
