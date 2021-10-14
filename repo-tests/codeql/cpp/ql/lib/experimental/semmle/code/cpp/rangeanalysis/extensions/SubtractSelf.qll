import experimental.semmle.code.cpp.models.interfaces.SimpleRangeAnalysisExpr

private class SelfSub extends SimpleRangeAnalysisExpr, SubExpr {
  SelfSub() {
    // Match `x - x` but not `myInt - (unsigned char)myInt`.
    getLeftOperand().getExplicitlyConverted().(VariableAccess).getTarget() =
      getRightOperand().getExplicitlyConverted().(VariableAccess).getTarget()
  }

  override float getLowerBounds() { result = 0 }

  override float getUpperBounds() { result = 0 }

  override predicate dependsOnChild(Expr child) { none() }
}
