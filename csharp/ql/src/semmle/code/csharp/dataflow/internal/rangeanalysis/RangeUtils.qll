/**
 * Provides predicates for range and modulus analysis.
 */

private import csharp
private import Ssa
private import SsaUtils
private import ConstantUtils
private import SsaReadPositionCommon
private import semmle.code.csharp.controlflow.Guards as G

private class BooleanValue = G::AbstractValues::BooleanValue;

/**
 * Holds if `v` is an `ExplicitDefinition` that equals `e + delta`.
 */
predicate ssaUpdateStep(ExplicitDefinition v, Expr e, int delta) {
  v.getADefinition().getExpr().(Assignment).getRValue() = e and delta = 0
  or
  v.getADefinition().getExpr().(PostIncrExpr).getOperand() = e and delta = 1
  or
  v.getADefinition().getExpr().(PreIncrExpr).getOperand() = e and delta = 1
  or
  v.getADefinition().getExpr().(PostDecrExpr).getOperand() = e and delta = -1
  or
  v.getADefinition().getExpr().(PreDecrExpr).getOperand() = e and delta = -1
  or
  v.getADefinition().getExpr().(AssignOperation) = e and delta = 0
}

/**
 * Gets a condition that tests whether `v` equals `e + delta`.
 *
 * If the condition evaluates to `testIsTrue`:
 * - `isEq = true`  : `v == e + delta`
 * - `isEq = false` : `v != e + delta`
 */
G::Guard eqFlowCond(Definition v, Expr e, int delta, boolean isEq, boolean testIsTrue) {
  exists(boolean eqpolarity |
    result.isEquality(ssaRead(v, delta), e, eqpolarity) and
    (testIsTrue = true or testIsTrue = false) and
    eqpolarity.booleanXor(testIsTrue).booleanNot() = isEq
  )
  or
  exists(
    boolean testIsTrue0, G::AbstractValues::BooleanValue b0, G::AbstractValues::BooleanValue b1
  |
    b1.getValue() = testIsTrue and b0.getValue() = testIsTrue0
  |
    G::Internal::impliesSteps(result, b1, eqFlowCond(v, e, delta, isEq, testIsTrue0), b0)
  )
}

/**
 * Holds if `e1 + delta` equals `e2`.
 */
predicate valueFlowStep(Expr e2, Expr e1, int delta) {
  e2.(AssignExpr).getRValue() = e1 and delta = 0
  or
  e2.(UnaryPlusExpr).getOperand() = e1 and delta = 0
  or
  e2.(PostIncrExpr).getOperand() = e1 and delta = 0
  or
  e2.(PostDecrExpr).getOperand() = e1 and delta = 0
  or
  e2.(PreIncrExpr).getOperand() = e1 and delta = 1
  or
  e2.(PreDecrExpr).getOperand() = e1 and delta = -1
  or
  // exists(ArrayCreationExpr a |
  //   arrayLengthDef(e2, a) and
  //   a.getDimension(0) = e1 and
  //   delta = 0
  // )
  // or
  exists(Expr x |
    e2.(AddExpr).getAnOperand() = e1 and
    e2.(AddExpr).getAnOperand() = x and
    not e1 = x
    or
    exists(AssignAddExpr add | add = e2 |
      add.getLValue() = e1 and add.getRValue() = x
      or
      add.getLValue() = x and add.getRValue() = e1
    )
  |
    x.(ConstantIntegerExpr).getIntValue() = delta
  )
  or
  exists(Expr x |
    exists(SubExpr sub |
      e2 = sub and
      sub.getLeftOperand() = e1 and
      sub.getRightOperand() = x
    )
    or
    exists(AssignSubExpr sub |
      e2 = sub and
      sub.getLValue() = e1 and
      sub.getRValue() = x
    )
  |
    x.(ConstantIntegerExpr).getIntValue() = -delta
  )
}

/**
 * Holds if `guard` controls the position `controlled` with the value `testIsTrue`.
 */
predicate guardControlsSsaRead(G::Guard guard, SsaReadPosition controlled, boolean testIsTrue) {
  exists(BooleanValue b | b.getValue() = testIsTrue |
    guard.controlsBasicBlock(controlled.(SsaReadPositionBlock).getBlock(), b)
  )
}
