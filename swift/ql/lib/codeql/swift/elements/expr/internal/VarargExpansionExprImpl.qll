private import codeql.swift.generated.expr.VarargExpansionExpr

module Impl {
  class VarargExpansionExpr extends Generated::VarargExpansionExpr {
    override string toStringImpl() { result = this.getSubExpr().toStringImpl() }
  }
}
