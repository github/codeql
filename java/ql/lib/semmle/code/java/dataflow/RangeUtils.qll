/**
 * Provides utility predicates for range analysis.
 */

import java
private import SSA
private import semmle.code.java.controlflow.internal.GuardsLogic
private import semmle.code.java.Constants
private import semmle.code.java.dataflow.RangeAnalysis
private import codeql.rangeanalysis.internal.RangeUtils

private module U = MakeUtils<Location, Sem, IntDelta>;

private predicate backEdge = U::backEdge/3;

predicate ssaRead = U::ssaRead/2;

predicate ssaUpdateStep = U::ssaUpdateStep/3;

predicate valueFlowStep = U::valueFlowStep/3;

predicate guardDirectlyControlsSsaRead = U::guardDirectlyControlsSsaRead/3;

predicate guardControlsSsaRead = U::guardControlsSsaRead/3;

predicate eqFlowCond = U::eqFlowCond/5;

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
  exists(ConditionalExpr cond, boolean branch | cond = e2 |
    cond.getBranchExpr(branch) = e1 and
    cond.getBranchExpr(branch.booleanNot()) instanceof NullLiteral
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
  or
  CalcConstants::calculateIntValue(e) = val
}

pragma[nomagic]
private predicate constantBooleanExpr(Expr e, boolean val) {
  e.(CompileTimeConstantExpr).getBooleanValue() = val
  or
  exists(SsaExplicitUpdate v, Expr src |
    e = v.getAUse() and
    src = v.getDefiningExpr().(VariableAssign).getSource() and
    constantBooleanExpr(src, val)
  )
  or
  CalcConstants::calculateBooleanValue(e) = val
}

pragma[nomagic]
private predicate constantStringExpr(Expr e, string val) {
  e.(CompileTimeConstantExpr).getStringValue() = val
  or
  exists(SsaExplicitUpdate v, Expr src |
    e = v.getAUse() and
    src = v.getDefiningExpr().(VariableAssign).getSource() and
    constantStringExpr(src, val)
  )
}

private boolean getBoolValue(Expr e) { constantBooleanExpr(e, result) }

private int getIntValue(Expr e) { constantIntegerExpr(e, result) }

private module CalcConstants = CalculateConstants<getBoolValue/1, getIntValue/1>;

/** An expression that always has the same integer value. */
class ConstantIntegerExpr extends Expr {
  ConstantIntegerExpr() { constantIntegerExpr(this, _) }

  /** Gets the integer value of this expression. */
  int getIntValue() { constantIntegerExpr(this, result) }
}

/** An expression that always has the same boolean value. */
class ConstantBooleanExpr extends Expr {
  ConstantBooleanExpr() { constantBooleanExpr(this, _) }

  /** Gets the boolean value of this expression. */
  boolean getBooleanValue() { constantBooleanExpr(this, result) }
}

/** An expression that always has the same string value. */
class ConstantStringExpr extends Expr {
  ConstantStringExpr() { constantStringExpr(this, _) }

  /** Get the string value of this expression. */
  string getStringValue() { constantStringExpr(this, result) }
}

/**
 * Holds if `e1 + delta` equals `e2`.
 */
predicate additionalValueFlowStep(Expr e2, Expr e1, int delta) {
  exists(ArrayCreationExpr a |
    arrayLengthDef(e2, a) and
    a.getDimension(0) = e1 and
    delta = 0
  )
}
