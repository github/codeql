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
}

private G::Guard eqFlowCondAbs(Definition def, Expr e, int delta, boolean isEq, G::AbstractValue v) {
  exists(boolean eqpolarity |
    result.isEquality(ssaRead(def, delta), e, eqpolarity) and
    eqpolarity.booleanXor(v.(BooleanValue).getValue()).booleanNot() = isEq
  )
  or
  exists(G::AbstractValue v0 |
    G::Internal::impliesSteps(result, v, eqFlowCondAbs(def, e, delta, isEq, v0), v0)
  )
}

/**
 * Gets a condition that tests whether `def` equals `e + delta`.
 *
 * If the condition evaluates to `testIsTrue`:
 * - `isEq = true`  : `def == e + delta`
 * - `isEq = false` : `def != e + delta`
 */
G::Guard eqFlowCond(Definition def, Expr e, int delta, boolean isEq, boolean testIsTrue) {
  exists(BooleanValue v |
    result = eqFlowCondAbs(def, e, delta, isEq, v) and
    testIsTrue = v.getValue()
  )
}

/**
 * Holds if `e1 + delta` equals `e2`.
 */
predicate valueFlowStep(Expr e2, Expr e1, int delta) {
  valueFlowStep(e2.(AssignOperation).getExpandedAssignment(), e1, delta)
  or
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
  exists(ConstantIntegerExpr x |
    e2.(AddExpr).getAnOperand() = e1 and
    e2.(AddExpr).getAnOperand() = x and
    not e1 = x
  |
    x.getIntValue() = delta
  )
  or
  exists(ConstantIntegerExpr x |
    exists(SubExpr sub |
      e2 = sub and
      sub.getLeftOperand() = e1 and
      sub.getRightOperand() = x
    )
  |
    x.getIntValue() = -delta
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
