import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis
import experimental.semmle.code.cpp.models.interfaces.SimpleRangeAnalysisExpr

class CustomAddFunctionCall extends SimpleRangeAnalysisExpr, FunctionCall {
  CustomAddFunctionCall() { this.getTarget().hasGlobalName("custom_add_function") }

  override float getLowerBounds() {
    exists(float lower0, float lower1 |
      lower0 = getFullyConvertedLowerBounds(this.getArgument(0)) and
      lower1 = getFullyConvertedLowerBounds(this.getArgument(1)) and
      // Note: this rounds toward 0, not -Inf as it should
      result = lower0 + lower1
    )
  }

  override float getUpperBounds() {
    exists(float upper0, float upper1 |
      upper0 = getFullyConvertedUpperBounds(this.getArgument(0)) and
      upper1 = getFullyConvertedUpperBounds(this.getArgument(1)) and
      // Note: this rounds toward 0, not Inf as it should
      result = upper0 + upper1
    )
  }

  override predicate dependsOnChild(Expr child) { child = this.getAnArgument() }
}

class SelfSub extends SimpleRangeAnalysisExpr, SubExpr {
  SelfSub() {
    getLeftOperand().(VariableAccess).getTarget() = getRightOperand().(VariableAccess).getTarget()
  }

  override float getLowerBounds() { result = 0 }

  override float getUpperBounds() { result = 0 }

  override predicate dependsOnChild(Expr child) { child = this.getAnOperand() }
}

from VariableAccess expr, float lower, float upper
where
  lower = lowerBound(expr) and
  upper = upperBound(expr)
select expr, lower, upper
