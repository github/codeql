/**
 * Provides utility predicates for range analysis.
 */

import java
private import SSA
private import semmle.code.java.controlflow.internal.GuardsLogic

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
  exists(SsaExplicitUpdate v, FieldRead arrlen |
    e = arrlen and
    arrlen.getField() instanceof ArrayLengthField and
    arrlen.getQualifier() = v.getAUse() and
    v.getDefiningExpr().(VariableAssign).getSource().(ArrayCreationExpr).getFirstDimensionSize() = val
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
  result.(ParExpr).getExpr() = ssaRead(v, delta)
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

private newtype TSsaReadPosition =
  TSsaReadPositionBlock(BasicBlock bb) { exists(SsaVariable v | bb = v.getAUse().getBasicBlock()) } or
  TSsaReadPositionPhiInputEdge(BasicBlock bbOrig, BasicBlock bbPhi) {
    exists(SsaPhiNode phi | phi.hasInputFromBlock(_, bbOrig) and bbPhi = phi.getBasicBlock())
  }

/**
 * A position at which an SSA variable is read. This includes both ordinary
 * reads occurring in basic blocks and input to phi nodes occurring along an
 * edge between two basic blocks.
 */
class SsaReadPosition extends TSsaReadPosition {
  /** Holds if `v` is read at this position. */
  abstract predicate hasReadOfVar(SsaVariable v);

  abstract string toString();
}

/** A basic block in which an SSA variable is read. */
class SsaReadPositionBlock extends SsaReadPosition, TSsaReadPositionBlock {
  /** Gets the basic block corresponding to this position. */
  BasicBlock getBlock() { this = TSsaReadPositionBlock(result) }

  override predicate hasReadOfVar(SsaVariable v) { getBlock() = v.getAUse().getBasicBlock() }

  override string toString() { result = "block" }
}

/**
 * An edge between two basic blocks where the latter block has an SSA phi
 * definition. The edge therefore has a read of an SSA variable serving as the
 * input to the phi node.
 */
class SsaReadPositionPhiInputEdge extends SsaReadPosition, TSsaReadPositionPhiInputEdge {
  /** Gets the head of the edge. */
  BasicBlock getOrigBlock() { this = TSsaReadPositionPhiInputEdge(result, _) }

  /** Gets the tail of the edge. */
  BasicBlock getPhiBlock() { this = TSsaReadPositionPhiInputEdge(_, result) }

  override predicate hasReadOfVar(SsaVariable v) {
    exists(SsaPhiNode phi |
      phi.hasInputFromBlock(v, getOrigBlock()) and
      getPhiBlock() = phi.getBasicBlock()
    )
  }

  /** Holds if `inp` is an input to `phi` along this edge. */
  predicate phiInput(SsaPhiNode phi, SsaVariable inp) {
    phi.hasInputFromBlock(inp, getOrigBlock()) and
    getPhiBlock() = phi.getBasicBlock()
  }

  override string toString() { result = "edge" }
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
  e2.(ParExpr).getExpr() = e1 and delta = 0
  or
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
  exists(SsaExplicitUpdate v, FieldRead arrlen |
    e2 = arrlen and
    arrlen.getField() instanceof ArrayLengthField and
    arrlen.getQualifier() = v.getAUse() and
    v.getDefiningExpr().(VariableAssign).getSource().(ArrayCreationExpr).getDimension(0) = e1 and
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
