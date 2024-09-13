private import codeql.swift.generated.expr.KeyPathDotExpr

module Impl {
  class KeyPathDotExpr extends Generated::KeyPathDotExpr {
    override string toString() { result = "\\...." }
  }
}
