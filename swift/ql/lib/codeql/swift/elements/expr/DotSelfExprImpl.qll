private import codeql.swift.generated.expr.DotSelfExpr

module Impl {
  class DotSelfExpr extends Generated::DotSelfExpr {
    override string toString() { result = ".self" }
  }
}
