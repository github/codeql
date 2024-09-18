private import codeql.swift.generated.expr.ArrayExpr

module Impl {
  class ArrayExpr extends Generated::ArrayExpr {
    override string toString() { result = "[...]" }
  }
}
