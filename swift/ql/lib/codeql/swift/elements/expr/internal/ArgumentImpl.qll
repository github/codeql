private import codeql.swift.generated.expr.Argument
private import codeql.swift.elements.expr.ApplyExpr

module Impl {
  class Argument extends Generated::Argument {
    override string toString() { result = this.getLabel() + ": " + this.getExpr().toString() }

    int getIndex() { any(ApplyExpr apply).getArgument(result) = this }

    ApplyExpr getApplyExpr() { result.getAnArgument() = this }
  }
}
