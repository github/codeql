private import codeql.swift.generated.expr.FloatLiteralExpr

module Impl {
  class FloatLiteralExpr extends Generated::FloatLiteralExpr {
    override string toStringImpl() { result = this.getStringValue() }

    override string getValueString() { result = this.getStringValue() }
  }
}
