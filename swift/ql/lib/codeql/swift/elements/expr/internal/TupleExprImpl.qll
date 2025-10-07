private import codeql.swift.generated.expr.TupleExpr

module Impl {
  class TupleExpr extends Generated::TupleExpr {
    override string toStringImpl() { result = "(...)" }
  }
}
