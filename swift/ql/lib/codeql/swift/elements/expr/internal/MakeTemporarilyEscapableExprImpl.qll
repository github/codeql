private import codeql.swift.generated.expr.MakeTemporarilyEscapableExpr

module Impl {
  class MakeTemporarilyEscapableExpr extends Generated::MakeTemporarilyEscapableExpr {
    override string toString() { result = this.getSubExpr().toString() }
  }
}
