private import codeql.swift.generated.expr.RebindSelfInInitializerExpr

module Impl {
  class RebindSelfInInitializerExpr extends Generated::RebindSelfInInitializerExpr {
    override string toString() { result = "self = ..." }
  }
}
