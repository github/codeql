private import cpp
private import experimental.semmle.code.cpp.models.interfaces.SimpleRangeAnalysisExpr

/**
 * Provides range analysis information for calls to `strlen` on literal strings.
 * For example, the range of `strlen("literal")` will be 7.
 */
class StrlenLiteralRangeExpr extends SimpleRangeAnalysisExpr, FunctionCall {
  StrlenLiteralRangeExpr() {
    getTarget().hasGlobalOrStdName("strlen") and getArgument(0).isConstant()
  }

  override int getLowerBounds() { result = getArgument(0).getValue().length() }

  override int getUpperBounds() { result = getArgument(0).getValue().length() }

  override predicate dependsOnChild(Expr e) { none() }
}
