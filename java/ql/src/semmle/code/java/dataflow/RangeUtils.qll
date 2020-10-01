/**
 * Provides utility predicates for range analysis.
 */

import java
private import SSA
private import semmle.code.java.controlflow.internal.GuardsLogic
private import semmle.code.java.dataflow.internal.rangeanalysis.SsaReadPositionCommon

/**
 * Holds if `v` is an input to `phi` that is not along a back edge, and the
 * only other input to `phi` is a `null` value.
 *
 * Note that the declared type of `phi` is `SsaVariable` instead of
 * `SsaPhiNode` in order for the reflexive case of `nonNullSsaFwdStep*(..)` to
 * have non-`SsaPhiNode` results.
 */
private predicate nonNullSsaFwdStep(SsaVariable v, SsaVariable phi) {
  exists(SsaExplicitUpdate vnull, SsaPhiNode phi0 | phi0 = phi |
    2 = strictcount(phi0.getAPhiInput()) and
    vnull = phi0.getAPhiInput() and
    v = phi0.getAPhiInput() and
    not backEdge(phi0, v, _) and
    vnull != v and
    vnull.getDefiningExpr().(VariableAssign).getSource() instanceof NullLiteral
  )
}

private predicate nonNullDefStep(Expr e1, Expr e2) {
  exists(ConditionalExpr cond | cond = e2 |
    cond.getTrueExpr() = e1 and cond.getFalseExpr() instanceof NullLiteral
    or
    cond.getFalseExpr() = e1 and cond.getTrueExpr() instanceof NullLiteral
  )
}

/**
 * Gets the definition of `v` provided that `v` is a non-null array with an
 * explicit `ArrayCreationExpr` definition and that the definition does not go
 * through a back edge.
 */
ArrayCreationExpr getArrayDef(SsaVariable v) {
  exists(Expr src |
    v.(SsaExplicitUpdate).getDefiningExpr().(VariableAssign).getSource() = src and
    nonNullDefStep*(result, src)
  )
  or
  exists(SsaVariable mid |
    result = getArrayDef(mid) and
    nonNullSsaFwdStep(mid, v)
  )
}

/**
 * Holds if `arrlen` is a read of an array `length` field on an array that, if
 * it is non-null, is defined by `def` and that the definition can reach
 * `arrlen` without going through a back edge.
 */
private predicate arrayLengthDef(FieldRead arrlen, ArrayCreationExpr def) {
  exists(SsaVariable arr |
    arrlen.getField() instanceof ArrayLengthField and
    arrlen.getQualifier() = arr.getAUse() and
    def = getArrayDef(arr)
  )
}

/** An expression that always has the same integer value. */
pragma[nomagic]
private predicate constantIntegerExpr(Expr e, int val) {
  e.(CompileTimeConstantExpr).getIntValue() = val
  or
  exists(SsaExplicitUpdate v, Expr src |
    e = v.getAUse() and
    src = v.getDefiningExpr().(VariableAssign).getSource() and
    constantIntegerExpr(src, val)
  )
  or
  exists(ArrayCreationExpr a |
    arrayLengthDef(e, a) and
    a.getFirstDimensionSize() = val
  )
  or
  exists(Field a, FieldRead arrlen |
    a.isFinal() and
    a.getInitializer().(ArrayCreationExpr).getFirstDimensionSize() = val and
    arrlen.getField() instanceof ArrayLengthField and
    arrlen.getQualifier() = a.getAnAccess() and
    e = arrlen
  )
}

/** An expression that always has the same integer value. */
class ConstantIntegerExpr extends Expr {
  ConstantIntegerExpr() { constantIntegerExpr(this, _) }

  /** Gets the integer value of this expression. */
  int getIntValue() { constantIntegerExpr(this, result) }
}

/**
 * Gets an expression that equals `v - d`.
 */
Expr ssaRead(SsaVariable v, int delta) {
  result = v.getAUse() and delta = 0
  or
  exists(int d1, ConstantIntegerExpr c |
    result.(AddExpr).hasOperands(ssaRead(v, d1), c) and
    delta = d1 - c.getIntValue()
  )
  or
  exists(SubExpr sub, int d1, ConstantIntegerExpr c |
    result = sub and
    sub.getLeftOperand() = ssaRead(v, d1) and
    sub.getRightOperand() = c and
    delta = d1 + c.getIntValue()
  )
  or
  v.(SsaExplicitUpdate).getDefiningExpr().(PreIncExpr) = result and delta = 0
  or
  v.(SsaExplicitUpdate).getDefiningExpr().(PreDecExpr) = result and delta = 0
  or
  v.(SsaExplicitUpdate).getDefiningExpr().(PostIncExpr) = result and delta = 1 // x++ === ++x - 1
  or
  v.(SsaExplicitUpdate).getDefiningExpr().(PostDecExpr) = result and delta = -1 // x-- === --x + 1
  or
  v.(SsaExplicitUpdate).getDefiningExpr().(Assignment) = result and delta = 0
  or
  result.(AssignExpr).getSource() = ssaRead(v, delta)
}

/**
 * Holds if `inp` is an input to `phi` along a back edge.
 */
predicate backEdge(SsaPhiNode phi, SsaVariable inp, SsaReadPositionPhiInputEdge edge) {
  edge.phiInput(phi, inp) and
  // Conservatively assume that every edge is a back edge if we don't have dominance information.
  (
    phi.getBasicBlock().bbDominates(edge.getOrigBlock()) or
    not hasDominanceInformation(edge.getOrigBlock())
  )
}

/**
 * Holds if `guard` directly controls the position `controlled` with the
 * value `testIsTrue`.
 */
predicate guardDirectlyControlsSsaRead(Guard guard, SsaReadPosition controlled, boolean testIsTrue) {
  guard.directlyControls(controlled.(SsaReadPositionBlock).getBlock(), testIsTrue)
  or
  exists(SsaReadPositionPhiInputEdge controlledEdge | controlledEdge = controlled |
    guard.directlyControls(controlledEdge.getOrigBlock(), testIsTrue) or
    guard.hasBranchEdge(controlledEdge.getOrigBlock(), controlledEdge.getPhiBlock(), testIsTrue)
  )
}

/**
 * Holds if `guard` controls the position `controlled` with the value `testIsTrue`.
 */
predicate guardControlsSsaRead(Guard guard, SsaReadPosition controlled, boolean testIsTrue) {
  guardDirectlyControlsSsaRead(guard, controlled, testIsTrue)
  or
  exists(Guard guard0, boolean testIsTrue0 |
    implies_v2(guard0, testIsTrue0, guard, testIsTrue) and
    guardControlsSsaRead(guard0, controlled, testIsTrue0)
  )
}

/**
 * Gets a condition that tests whether `v` equals `e + delta`.
 *
 * If the condition evaluates to `testIsTrue`:
 * - `isEq = true`  : `v == e + delta`
 * - `isEq = false` : `v != e + delta`
 */
Guard eqFlowCond(SsaVariable v, Expr e, int delta, boolean isEq, boolean testIsTrue) {
  exists(boolean eqpolarity |
    result.isEquality(ssaRead(v, delta), e, eqpolarity) and
    (testIsTrue = true or testIsTrue = false) and
    eqpolarity.booleanXor(testIsTrue).booleanNot() = isEq
  )
  or
  exists(boolean testIsTrue0 |
    implies_v2(result, testIsTrue, eqFlowCond(v, e, delta, isEq, testIsTrue0), testIsTrue0)
  )
}

/**
 * Holds if `v` is an `SsaExplicitUpdate` that equals `e + delta`.
 */
predicate ssaUpdateStep(SsaExplicitUpdate v, Expr e, int delta) {
  v.getDefiningExpr().(VariableAssign).getSource() = e and delta = 0
  or
  v.getDefiningExpr().(PostIncExpr).getExpr() = e and delta = 1
  or
  v.getDefiningExpr().(PreIncExpr).getExpr() = e and delta = 1
  or
  v.getDefiningExpr().(PostDecExpr).getExpr() = e and delta = -1
  or
  v.getDefiningExpr().(PreDecExpr).getExpr() = e and delta = -1
  or
  v.getDefiningExpr().(AssignOp) = e and delta = 0
}

/**
 * Holds if `e1 + delta` equals `e2`.
 */
predicate valueFlowStep(Expr e2, Expr e1, int delta) {
  e2.(AssignExpr).getSource() = e1 and delta = 0
  or
  e2.(PlusExpr).getExpr() = e1 and delta = 0
  or
  e2.(PostIncExpr).getExpr() = e1 and delta = 0
  or
  e2.(PostDecExpr).getExpr() = e1 and delta = 0
  or
  e2.(PreIncExpr).getExpr() = e1 and delta = 1
  or
  e2.(PreDecExpr).getExpr() = e1 and delta = -1
  or
  exists(ArrayCreationExpr a |
    arrayLengthDef(e2, a) and
    a.getDimension(0) = e1 and
    delta = 0
  )
  or
  exists(Expr x |
    e2.(AddExpr).hasOperands(e1, x)
    or
    exists(AssignAddExpr add | add = e2 |
      add.getDest() = e1 and add.getRhs() = x
      or
      add.getDest() = x and add.getRhs() = e1
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
      sub.getDest() = e1 and
      sub.getRhs() = x
    )
  |
    x.(ConstantIntegerExpr).getIntValue() = -delta
  )
}
