import experimental.semmle.code.cpp.models.interfaces.SimpleRangeAnalysisExpr

private class SelfSub extends SimpleRangeAnalysisExpr, SubExpr {
  SelfSub() {
    // Match `x - x` but not `myInt - (unsigned char)myInt`.
    this.getLeftOperand().getExplicitlyConverted().(VariableAccess).getTarget() =
      this.getRightOperand().getExplicitlyConverted().(VariableAccess).getTarget()
  }

  override QlBuiltins::BigInt getLowerBounds() { result = 0.toBigInt() }

  override QlBuiltins::BigInt getUpperBounds() { result = 0.toBigInt() }

  override predicate dependsOnChild(Expr child) { none() }
}
