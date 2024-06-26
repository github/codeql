private import cpp
private import experimental.semmle.code.cpp.models.interfaces.SimpleRangeAnalysisExpr

/**
 * Provides range analysis information for calls to `strlen` on literal strings.
 * For example, the range of `strlen("literal")` will be 7.
 */
class StrlenLiteralRangeExpr extends SimpleRangeAnalysisExpr, FunctionCall {
  StrlenLiteralRangeExpr() {
    this.getTarget().hasGlobalOrStdName("strlen") and this.getArgument(0).isConstant()
  }

  override QlBuiltins::BigInt getLowerBounds() {
    result = this.getArgument(0).getValue().length().toBigInt()
  }

  override QlBuiltins::BigInt getUpperBounds() {
    result = this.getArgument(0).getValue().length().toBigInt()
  }

  override predicate dependsOnChild(Expr e) { none() }
}
