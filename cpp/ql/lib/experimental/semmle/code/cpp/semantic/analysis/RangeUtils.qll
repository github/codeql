/**
 * Provides utility predicates for range analysis.
 */

private import experimental.semmle.code.cpp.semantic.Semantic
private import RangeAnalysisSpecific as Specific
private import ConstantAnalysis

/**
 * Gets an expression that equals `v - d`.
 */
SemExpr semSsaRead(SemSsaVariable v, int delta) {
  // There are various language-specific extension points that can be removed once we no longer
  // expect to match the original Java implementation's results exactly.
  result = v.getAUse() and delta = 0
  or
  exists(int d1, SemConstantIntegerExpr c |
    result.(SemAddExpr).hasOperands(semSsaRead(v, d1), c) and
    delta = d1 - c.getIntValue() and
    not Specific::ignoreSsaReadArithmeticExpr(result)
  )
  or
  exists(SemSubExpr sub, int d1, SemConstantIntegerExpr c |
    result = sub and
    sub.getLeftOperand() = semSsaRead(v, d1) and
    sub.getRightOperand() = c and
    delta = d1 + c.getIntValue() and
    not Specific::ignoreSsaReadArithmeticExpr(result)
  )
  or
  result = v.(SemSsaExplicitUpdate).getSourceExpr() and
  delta = 0 and
  not Specific::ignoreSsaReadAssignment(v)
  or
  result = Specific::specificSsaRead(v, delta)
  or
  result.(SemCopyValueExpr).getOperand() = semSsaRead(v, delta) and
  not Specific::ignoreSsaReadCopy(result)
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
SemGuard semEqFlowCond(SemSsaVariable v, SemExpr e, int delta, boolean isEq, boolean testIsTrue) {
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
predicate semSsaUpdateStep(SemSsaExplicitUpdate v, SemExpr e, int delta) {
  exists(SemExpr defExpr | defExpr = v.getSourceExpr() |
    defExpr.(SemCopyValueExpr).getOperand() = e and delta = 0
    or
    defExpr.(SemStoreExpr).getOperand() = e and delta = 0
    or
    defExpr.(SemAddOneExpr).getOperand() = e and delta = 1
    or
    defExpr.(SemSubOneExpr).getOperand() = e and delta = -1
    or
    e = defExpr and
    not (
      defExpr instanceof SemCopyValueExpr or
      defExpr instanceof SemStoreExpr or
      defExpr instanceof SemAddOneExpr or
      defExpr instanceof SemSubOneExpr
    ) and
    delta = 0
  )
}

/**
 * Holds if `e1 + delta` equals `e2`.
 */
predicate semValueFlowStep(SemExpr e2, SemExpr e1, int delta) {
  e2.(SemCopyValueExpr).getOperand() = e1 and delta = 0
  or
  e2.(SemStoreExpr).getOperand() = e1 and delta = 0
  or
  e2.(SemAddOneExpr).getOperand() = e1 and delta = 1
  or
  e2.(SemSubOneExpr).getOperand() = e1 and delta = -1
  or
  Specific::additionalValueFlowStep(e2, e1, delta)
  or
  exists(SemExpr x | e2.(SemAddExpr).hasOperands(e1, x) |
    x.(SemConstantIntegerExpr).getIntValue() = delta
  )
  or
  exists(SemExpr x, SemSubExpr sub |
    e2 = sub and
    sub.getLeftOperand() = e1 and
    sub.getRightOperand() = x
  |
    x.(SemConstantIntegerExpr).getIntValue() = -delta
  )
}

/**
 * Gets the type used to track the specified expression's range information.
 *
 * Usually, this just `e.getSemType()`, but the language can override this to track immutable boxed
 * primitive types as the underlying primitive type.
 */
SemType getTrackedType(SemExpr e) {
  result = Specific::getAlternateType(e)
  or
  not exists(Specific::getAlternateType(e)) and result = e.getSemType()
}

/**
 * Gets the type used to track the specified source variable's range information.
 *
 * Usually, this just `e.getType()`, but the language can override this to track immutable boxed
 * primitive types as the underlying primitive type.
 */
SemType getTrackedTypeForSsaVariable(SemSsaVariable var) {
  result = Specific::getAlternateTypeForSsaVariable(var)
  or
  not exists(Specific::getAlternateTypeForSsaVariable(var)) and result = var.getType()
}
