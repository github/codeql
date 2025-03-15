private import codeql.swift.generated.expr.Argument
private import codeql.swift.elements.expr.ApplyExpr

module Impl {
  class Argument extends Generated::Argument {
    override string toStringImpl() {
      result = this.getLabel() + ": " + this.getExpr().toStringImpl()
    }

    int getIndex() { any(ApplyExpr apply).getArgument(result) = this }

    ApplyExpr getApplyExpr() { result.getAnArgument() = this }
  }
}
