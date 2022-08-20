import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis
import semmle.code.cpp.rangeanalysis.RangeAnalysisUtils
import experimental.semmle.code.cpp.models.interfaces.SimpleRangeAnalysisExpr
import experimental.semmle.code.cpp.models.interfaces.SimpleRangeAnalysisDefinition

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
    this.getLeftOperand().(VariableAccess).getTarget() =
      this.getRightOperand().(VariableAccess).getTarget()
  }

  override float getLowerBounds() { result = 0 }

  override float getUpperBounds() { result = 0 }

  override predicate dependsOnChild(Expr child) { child = this.getAnOperand() }
}

/**
 * A definition for test purposes of a parameter `p` that starts with a
 * special prefix. This class is written to exploit how QL behaves when class
 * fields are not functionally determined by `this`. When multiple parameters
 * of the same function have the special prefix, there is still only one
 * instance of this class.
 */
class MagicParameterName extends SimpleRangeAnalysisDefinition {
  Parameter p;
  float value;

  MagicParameterName() {
    this.definedByParameter(p) and
    value = p.getName().regexpCapture("magic_name_at_most_(\\d+)", 1).toFloat()
  }

  override predicate hasRangeInformationFor(StackVariable v) { v = p }

  override predicate dependsOnExpr(StackVariable v, Expr e) {
    // No dependencies. This sample class yields constant values.
    none()
  }

  override float getLowerBounds(StackVariable var) {
    var = p and
    result = typeLowerBound(p.getUnspecifiedType())
  }

  override float getUpperBounds(StackVariable var) {
    var = p and
    result = value
  }
}

from VariableAccess expr, float lower, float upper
where
  lower = lowerBound(expr) and
  upper = upperBound(expr)
select expr, lower, upper
