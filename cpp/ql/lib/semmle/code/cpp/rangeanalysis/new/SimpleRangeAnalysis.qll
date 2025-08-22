/**
 * Wrapper for the semantic range analysis library that mimics the
 * interface of the simple range analysis library.
 */

private import cpp
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.rangeanalysis.new.internal.semantic.SemanticBound
private import semmle.code.cpp.rangeanalysis.new.internal.semantic.SemanticExprSpecific
private import semmle.code.cpp.rangeanalysis.new.internal.semantic.analysis.RangeAnalysis
private import semmle.code.cpp.rangeanalysis.new.internal.semantic.analysis.RangeAnalysisImpl
private import semmle.code.cpp.rangeanalysis.RangeAnalysisUtils

/**
 * Gets the lower bound of the expression.
 *
 * Note: expressions in C/C++ are often implicitly or explicitly cast to a
 * different result type. Such casts can cause the value of the expression
 * to overflow or to be truncated. This predicate computes the lower bound
 * of the expression without including the effect of the casts. To compute
 * the lower bound of the expression after all the casts have been applied,
 * call `lowerBound` like this:
 *
 *    `lowerBound(expr.getFullyConverted())`
 */
float lowerBound(Expr expr) {
  exists(Instruction i, ConstantBounds::SemBound b |
    i.getAst() = expr and b instanceof ConstantBounds::SemZeroBound
  |
    ConstantStage::semBounded(getSemanticExpr(i), b, result, false, _)
  )
}

/**
 * Gets the upper bound of the expression.
 *
 * Note: expressions in C/C++ are often implicitly or explicitly cast to a
 * different result type. Such casts can cause the value of the expression
 * to overflow or to be truncated. This predicate computes the upper bound
 * of the expression without including the effect of the casts. To compute
 * the upper bound of the expression after all the casts have been applied,
 * call `upperBound` like this:
 *
 *    `upperBound(expr.getFullyConverted())`
 */
float upperBound(Expr expr) {
  exists(Instruction i, ConstantBounds::SemBound b |
    i.getAst() = expr and b instanceof ConstantBounds::SemZeroBound
  |
    ConstantStage::semBounded(getSemanticExpr(i), b, result, true, _)
  )
}

/**
 * Holds if the upper bound of `expr` may have been widened. This means the
 * upper bound is in practice likely to be overly wide.
 */
predicate upperBoundMayBeWidened(Expr e) { none() }

/**
 * Holds if `expr` has a provably empty range. For example:
 *
 *   10 < expr and expr < 5
 *
 * The range of an expression can only be empty if it can never be
 * executed. For example:
 *
 * ```cpp
 * if (10 < x) {
 *   if (x < 5) {
 *     // Unreachable code
 *     return x; // x has an empty range: 10 < x && x < 5
 *   }
 * }
 * ```
 */
predicate exprWithEmptyRange(Expr expr) { lowerBound(expr) > upperBound(expr) }

/** Holds if the definition might overflow negatively. */
predicate defMightOverflowNegatively(RangeSsaDefinition def, StackVariable v) { none() }

/** Holds if the definition might overflow positively. */
predicate defMightOverflowPositively(RangeSsaDefinition def, StackVariable v) { none() }

/**
 * Holds if the definition might overflow (either positively or
 * negatively).
 */
predicate defMightOverflow(RangeSsaDefinition def, StackVariable v) {
  defMightOverflowNegatively(def, v) or
  defMightOverflowPositively(def, v)
}

/**
 * Holds if the expression might overflow negatively. This predicate
 * does not consider the possibility that the expression might overflow
 * due to a conversion.
 */
predicate exprMightOverflowNegatively(Expr expr) {
  lowerBound(expr) < exprMinVal(expr)
  or
  exists(SemanticExprConfig::Expr semExpr |
    semExpr.getAst() = expr and
    ConstantStage::potentiallyOverflowingExpr(false, semExpr) and
    not ConstantStage::initialBounded(semExpr, _, _, false, _, _, _)
  )
}

/**
 * Holds if the expression might overflow negatively. Conversions
 * are also taken into account. For example the expression
 * `(int16)(x+y)` might overflow due to the `(int16)` cast, rather than
 * due to the addition.
 */
predicate convertedExprMightOverflowNegatively(Expr expr) {
  exprMightOverflowNegatively(expr) or
  convertedExprMightOverflowNegatively(expr.getConversion())
}

/**
 * Holds if the expression might overflow positively. This predicate
 * does not consider the possibility that the expression might overflow
 * due to a conversion.
 */
predicate exprMightOverflowPositively(Expr expr) {
  upperBound(expr) > exprMaxVal(expr)
  or
  exists(SemanticExprConfig::Expr semExpr |
    semExpr.getAst() = expr and
    ConstantStage::potentiallyOverflowingExpr(true, semExpr) and
    not ConstantStage::initialBounded(semExpr, _, _, true, _, _, _)
  )
}

/**
 * Holds if the expression might overflow positively. Conversions
 * are also taken into account. For example the expression
 * `(int16)(x+y)` might overflow due to the `(int16)` cast, rather than
 * due to the addition.
 */
predicate convertedExprMightOverflowPositively(Expr expr) {
  exprMightOverflowPositively(expr) or
  convertedExprMightOverflowPositively(expr.getConversion())
}

/**
 * Holds if the expression might overflow (either positively or
 * negatively). The possibility that the expression might overflow
 * due to an implicit or explicit cast is also considered.
 */
predicate convertedExprMightOverflow(Expr expr) {
  convertedExprMightOverflowNegatively(expr) or
  convertedExprMightOverflowPositively(expr)
}
