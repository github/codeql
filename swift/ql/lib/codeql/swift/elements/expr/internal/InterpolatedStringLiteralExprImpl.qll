private import codeql.swift.generated.expr.InterpolatedStringLiteralExpr

module Impl {
  class InterpolatedStringLiteralExpr extends Generated::InterpolatedStringLiteralExpr {
    override string toString() { result = "\"...\"" }
  }
}
