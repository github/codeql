/**
 * Provides utility predicates for range analysis.
 */

private import semmle.code.cpp.rangeanalysis.new.internal.semantic.Semantic
private import RangeAnalysisRelativeSpecific
private import codeql.rangeanalysis.RangeAnalysis
private import RangeAnalysisImpl
private import ConstantAnalysis

module RangeUtil<DeltaSig D, LangSig<Sem, D> Lang> implements UtilSig<Sem, D> {
  /**
   * Holds if `e1 + delta` equals `e2`.
   */
  predicate semValueFlowStep(SemExpr e2, SemExpr e1, D::Delta delta) {
    e2.(SemCopyValueExpr).getOperand() = e1 and delta = D::fromFloat(0)
    or
    e2.(SemStoreExpr).getOperand() = e1 and delta = D::fromFloat(0)
    or
    e2.(SemAddOneExpr).getOperand() = e1 and delta = D::fromFloat(1)
    or
    e2.(SemSubOneExpr).getOperand() = e1 and delta = D::fromFloat(-1)
    or
    Lang::additionalValueFlowStep(e2, e1, delta)
    or
    exists(SemExpr x | e2.(SemAddExpr).hasOperands(e1, x) |
      D::fromInt(x.(SemConstantIntegerExpr).getIntValue()) = delta
    )
    or
    exists(SemExpr x, SemSubExpr sub |
      e2 = sub and
      sub.getLeftOperand() = e1 and
      sub.getRightOperand() = x
    |
      D::fromInt(-x.(SemConstantIntegerExpr).getIntValue()) = delta
    )
  }

  /**
   * Gets the type used to track the specified expression's range information.
   *
   * Usually, this just `e.getSemType()`, but the language can override this to track immutable boxed
   * primitive types as the underlying primitive type.
   */
  SemType getTrackedType(SemExpr e) {
    result = Lang::getAlternateType(e)
    or
    not exists(Lang::getAlternateType(e)) and result = e.getSemType()
  }

  /**
   * Gets the type used to track the specified source variable's range information.
   *
   * Usually, this just `e.getType()`, but the language can override this to track immutable boxed
   * primitive types as the underlying primitive type.
   */
  SemType getTrackedTypeForSsaVariable(SemSsaVariable var) {
    result = Lang::getAlternateTypeForSsaVariable(var)
    or
    not exists(Lang::getAlternateTypeForSsaVariable(var)) and result = var.getType()
  }
}
