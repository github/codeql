/**
 * Provides utility predicates for range analysis.
 */

private import semmle.code.java.semantic.SemanticCFG
private import semmle.code.java.semantic.SemanticExpr
private import semmle.code.java.semantic.SemanticGuard
private import semmle.code.java.semantic.SemanticSSA
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
 * Non-semantic interface wrappers
 *
 * Several types and predicates here wrap semantic types and predicates from other files. The non-
 * semantic wrappers are included here because clients that imported `RangeUtils.qll` expect to find
 * these here.
 */
private module Java {
  private import java
  private import SSA
  private import semmle.code.java.dataflow.internal.rangeanalysis.SsaReadPositionCommon
  import ArrayLengthFlow // Public for backward compatibility

  predicate ssaUpdateStep(SsaExplicitUpdate v, Expr e, int delta) {
    semSsaUpdateStep(getSemanticSsaVariable(v), getSemanticExpr(e), delta)
  }

  LanguageGuard eqFlowCond(SsaVariable v, Expr e, int delta, boolean isEq, boolean testIsTrue) {
    result =
      getLanguageGuard(semEqFlowCond(getSemanticSsaVariable(v), getSemanticExpr(e), delta, isEq,
          testIsTrue))
  }

  predicate valueFlowStep(Expr e2, Expr e1, int delta) {
    semValueFlowStep(getSemanticExpr(e2), getSemanticExpr(e1), delta)
  }

  predicate guardControlsSsaRead(LanguageGuard guard, SsaReadPosition controlled, boolean testIsTrue) {
    semGuardControlsSsaRead(getSemanticGuard(guard), getSemanticSsaReadPosition(controlled),
      testIsTrue)
  }

  predicate guardDirectlyControlsSsaRead(
    LanguageGuard guard, SsaReadPosition controlled, boolean testIsTrue
  ) {
    semGuardDirectlyControlsSsaRead(getSemanticGuard(guard), getSemanticSsaReadPosition(controlled),
      testIsTrue)
  }

  Expr ssaRead(SsaVariable v, int delta) {
    result = getJavaExpr(semSsaRead(getSemanticSsaVariable(v), delta))
  }

  predicate backEdge(SsaPhiNode phi, SsaVariable inp, SsaReadPositionPhiInputEdge edge) {
    semBackEdge(getSemanticSsaVariable(phi), getSemanticSsaVariable(inp),
      getSemanticSsaReadPosition(edge))
  }

  /** An expression that always has the same integer value. */
  class ConstantIntegerExpr extends Expr {
    final SemConstantIntegerExpr expr;

    ConstantIntegerExpr() { expr = getSemanticExpr(this) }

    final int getIntValue() { result = expr.getIntValue() }
  }
}

import Java
