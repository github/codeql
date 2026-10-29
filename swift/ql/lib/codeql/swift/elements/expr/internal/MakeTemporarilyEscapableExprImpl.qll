private import codeql.swift.generated.expr.MakeTemporarilyEscapableExpr

module Impl {
  class MakeTemporarilyEscapableExpr extends Generated::MakeTemporarilyEscapableExpr {
    override string toStringImpl() { result = this.getSubExpr().toStringImpl() }
  }
}
