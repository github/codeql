private import codeql.swift.generated.expr.NilLiteralExpr

module Impl {
  class NilLiteralExpr extends Generated::NilLiteralExpr {
    override string toString() { result = "nil" }
  }
}
