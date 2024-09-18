private import codeql.swift.generated.expr.ForceValueExpr

module Impl {
  class ForceValueExpr extends Generated::ForceValueExpr {
    override string toString() { result = "...!" }
  }
}
