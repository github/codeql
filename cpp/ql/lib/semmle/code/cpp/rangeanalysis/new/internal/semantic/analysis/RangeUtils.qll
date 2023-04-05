/**
 * Provides utility predicates for range analysis.
 */

private import semmle.code.cpp.rangeanalysis.new.internal.semantic.Semantic
private import RangeAnalysisSpecific
private import RangeAnalysisStage as Range
private import ConstantAnalysis

module RangeUtil<Range::DeltaSig D, Range::LangSig<D> Lang> implements Range::UtilSig<D> {
  /**
   * Gets an expression that equals `v - d`.
   */
  SemExpr semSsaRead(SemSsaVariable v, D::Delta delta) {
    // There are various language-specific extension points that can be removed once we no longer
    // expect to match the original Java implementation's results exactly.
    result = v.getAUse() and delta = D::fromInt(0)
    or
    exists(D::Delta d1, SemConstantIntegerExpr c |
      result.(SemAddExpr).hasOperands(semSsaRead(v, d1), c) and
      delta = D::fromFloat(D::toFloat(d1) - c.getIntValue()) and
      not Lang::ignoreSsaReadArithmeticExpr(result)
    )
    or
    exists(SemSubExpr sub, D::Delta d1, SemConstantIntegerExpr c |
      result = sub and
      sub.getLeftOperand() = semSsaRead(v, d1) and
      sub.getRightOperand() = c and
      delta = D::fromFloat(D::toFloat(d1) + c.getIntValue()) and
      not Lang::ignoreSsaReadArithmeticExpr(result)
    )
    or
    result = v.(SemSsaExplicitUpdate).getSourceExpr() and
    delta = D::fromFloat(0) and
    not Lang::ignoreSsaReadAssignment(v)
    or
    result = Lang::specificSsaRead(v, delta)
    or
    result.(SemCopyValueExpr).getOperand() = semSsaRead(v, delta) and
    not Lang::ignoreSsaReadCopy(result)
    or
    result.(SemStoreExpr).getOperand() = semSsaRead(v, delta)
  }

  /**
   * Gets a condition that tests whether `v` equals `e + delta`.
   *
   * If the condition evaluates to `testIsTrue`:
   * - `isEq = true`  : `v == e + delta`
   * - `isEq = false` : `v != e + delta`
   */
  SemGuard semEqFlowCond(
    SemSsaVariable v, SemExpr e, D::Delta delta, boolean isEq, boolean testIsTrue
  ) {
    exists(boolean eqpolarity |
      result.isEquality(semSsaRead(v, delta), e, eqpolarity) and
      (testIsTrue = true or testIsTrue = false) and
      eqpolarity.booleanXor(testIsTrue).booleanNot() = isEq
    )
    or
    exists(boolean testIsTrue0 |
      semImplies_v2(result, testIsTrue, semEqFlowCond(v, e, delta, isEq, testIsTrue0), testIsTrue0)
    )
  }

  /**
   * Holds if `v` is an `SsaExplicitUpdate` that equals `e + delta`.
   */
  predicate semSsaUpdateStep(SemSsaExplicitUpdate v, SemExpr e, D::Delta delta) {
    exists(SemExpr defExpr | defExpr = v.getSourceExpr() |
      defExpr.(SemCopyValueExpr).getOperand() = e and delta = D::fromFloat(0)
      or
      defExpr.(SemStoreExpr).getOperand() = e and delta = D::fromFloat(0)
      or
      defExpr.(SemAddOneExpr).getOperand() = e and delta = D::fromFloat(1)
      or
      defExpr.(SemSubOneExpr).getOperand() = e and delta = D::fromFloat(-1)
      or
      e = defExpr and
      not (
        defExpr instanceof SemCopyValueExpr or
        defExpr instanceof SemStoreExpr or
        defExpr instanceof SemAddOneExpr or
        defExpr instanceof SemSubOneExpr
      ) and
      delta = D::fromFloat(0)
    )
  }

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
