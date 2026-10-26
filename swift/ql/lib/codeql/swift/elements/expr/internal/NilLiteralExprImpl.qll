private import codeql.swift.generated.expr.NilLiteralExpr

module Impl {
  class NilLiteralExpr extends Generated::NilLiteralExpr {
    override string toStringImpl() { result = "nil" }
  }
}
