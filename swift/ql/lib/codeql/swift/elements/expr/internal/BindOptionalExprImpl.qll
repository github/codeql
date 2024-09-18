private import codeql.swift.generated.expr.BindOptionalExpr

module Impl {
  class BindOptionalExpr extends Generated::BindOptionalExpr {
    override string toString() { result = "...?" }
  }
}
