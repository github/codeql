private import codeql.swift.generated.expr.KeyPathApplicationExpr

module Impl {
  class KeyPathApplicationExpr extends Generated::KeyPathApplicationExpr {
    override string toString() { result = "\\...[...]" }
  }
}
