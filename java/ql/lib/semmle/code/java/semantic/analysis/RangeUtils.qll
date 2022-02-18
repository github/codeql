/**
 * Provides utility predicates for range analysis.
 */

private import semmle.code.java.semantic.SemanticCFG
private import semmle.code.java.semantic.SemanticExpr
private import semmle.code.java.semantic.SemanticGuard
private import semmle.code.java.semantic.SemanticSSA
private import semmle.code.java.semantic.SemanticType
private import RangeAnalysisSpecific as Specific
private import ConstantAnalysis

/**
 * Gets an expression that equals `v - d`.
 */
SemExpr semSsaRead(SemSsaVariable v, int delta) {
  result = v.getAUse() and delta = 0
  or
  exists(int d1, SemConstantIntegerExpr c |
    result.(SemAddExpr).hasOperands(semSsaRead(v, d1), c) and
    delta = d1 - c.getIntValue()
  )
  or
  exists(SemSubExpr sub, int d1, SemConstantIntegerExpr c |
    result = sub and
    sub.getLeftOperand() = semSsaRead(v, d1) and
    sub.getRightOperand() = c and
    delta = d1 + c.getIntValue()
  )
  or
  v.(SemSsaExplicitUpdate).getDefiningExpr().(SemPreIncExpr) = result and delta = 0
  or
  v.(SemSsaExplicitUpdate).getDefiningExpr().(SemPreDecExpr) = result and delta = 0
  or
  v.(SemSsaExplicitUpdate).getDefiningExpr().(SemPostIncExpr) = result and delta = 1 // x++ === ++x - 1
  or
  v.(SemSsaExplicitUpdate).getDefiningExpr().(SemPostDecExpr) = result and delta = -1 // x-- === --x + 1
  or
  v.(SemSsaExplicitUpdate).getDefiningExpr().(SemAssignment) = result and delta = 0
  or
  result.(SemAssignExpr).getRhs() = semSsaRead(v, delta)
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
  v.getDefiningExpr().(SemVariableAssign).getSource() = e and delta = 0
  or
  v.getDefiningExpr().(SemPostIncExpr).getExpr() = e and delta = 1
  or
  v.getDefiningExpr().(SemPreIncExpr).getExpr() = e and delta = 1
  or
  v.getDefiningExpr().(SemPostDecExpr).getExpr() = e and delta = -1
  or
  v.getDefiningExpr().(SemPreDecExpr).getExpr() = e and delta = -1
  or
  v.getDefiningExpr().(SemAssignOp) = e and delta = 0
}

/**
 * Holds if `e1 + delta` equals `e2`.
 */
predicate semValueFlowStep(SemExpr e2, SemExpr e1, int delta) {
  e2.(SemAssignExpr).getRhs() = e1 and delta = 0
  or
  e2.(SemPlusExpr).getExpr() = e1 and delta = 0
  or
  e2.(SemPostIncExpr).getExpr() = e1 and delta = 0
  or
  e2.(SemPostDecExpr).getExpr() = e1 and delta = 0
  or
  e2.(SemPreIncExpr).getExpr() = e1 and delta = 1
  or
  e2.(SemPreDecExpr).getExpr() = e1 and delta = -1
  or
  Specific::additionalValueFlowStep(e2, e1, delta)
  or
  exists(SemExpr x |
    e2.(SemAddExpr).hasOperands(e1, x)
    or
    exists(SemAssignAddExpr add | add = e2 |
      add.getDest() = e1 and add.getRhs() = x
      or
      add.getDest() = x and add.getRhs() = e1
    )
  |
    x.(SemConstantIntegerExpr).getIntValue() = delta
  )
  or
  exists(SemExpr x |
    exists(SemSubExpr sub |
      e2 = sub and
      sub.getLeftOperand() = e1 and
      sub.getRightOperand() = x
    )
    or
    exists(SemAssignSubExpr sub |
      e2 = sub and
      sub.getDest() = e1 and
      sub.getRhs() = x
    )
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
