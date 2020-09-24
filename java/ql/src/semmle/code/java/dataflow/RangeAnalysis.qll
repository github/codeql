/**
 * Provides classes and predicates for range analysis.
 *
 * An inferred bound can either be a specific integer, the abstract value of an
 * SSA variable, or the abstract value of an interesting expression. The latter
 * category includes array lengths that are not SSA variables.
 *
 * If an inferred bound relies directly on a condition, then this condition is
 * reported as the reason for the bound.
 */

/*
 * This library tackles range analysis as a flow problem. Consider e.g.:
 * ```
 *   len = arr.length;
 *   if (x < len) { ... y = x-1; ... y ... }
 * ```
 * In this case we would like to infer `y <= arr.length - 2`, and this is
 * accomplished by tracking the bound through a sequence of steps:
 * ```
 *   arr.length --> len = .. --> x < len --> x-1 --> y = .. --> y
 * ```
 *
 * In its simplest form the step relation `E1 --> E2` relates two expressions
 * such that `E1 <= B` implies `E2 <= B` for any `B` (with a second separate
 * step relation handling lower bounds). Examples of such steps include
 * assignments `E2 = E1` and conditions `x <= E1` where `E2` is a use of `x`
 * guarded by the condition.
 *
 * In order to handle subtractions and additions with constants, and strict
 * comparisons, the step relation is augmented with an integer delta. With this
 * generalization `E1 --(delta)--> E2` relates two expressions and an integer
 * such that `E1 <= B` implies `E2 <= B + delta` for any `B`. This corresponds
 * to the predicate `boundFlowStep`.
 *
 * The complete range analysis is then implemented as the transitive closure of
 * the step relation summing the deltas along the way. If `E1` transitively
 * steps to `E2`, `delta` is the sum of deltas along the path, and `B` is an
 * interesting bound equal to the value of `E1` then `E2 <= B + delta`. This
 * corresponds to the predicate `bounded`.
 *
 * Phi nodes need a little bit of extra handling. Consider `x0 = phi(x1, x2)`.
 * There are essentially two cases:
 * - If `x1 <= B + d1` and `x2 <= B + d2` then `x0 <= B + max(d1,d2)`.
 * - If `x1 <= B + d1` and `x2 <= x0 + d2` with `d2 <= 0` then `x0 <= B + d1`.
 * The first case is for whenever a bound can be proven without taking looping
 * into account. The second case is relevant when `x2` comes from a back-edge
 * where we can prove that the variable has been non-increasing through the
 * loop-iteration as this means that any upper bound that holds prior to the
 * loop also holds for the variable during the loop.
 * This generalizes to a phi node with `n` inputs, so if
 * `x0 = phi(x1, ..., xn)` and `xi <= B + delta` for one of the inputs, then we
 * also have `x0 <= B + delta` if we can prove either:
 * - `xj <= B + d` with `d <= delta` or
 * - `xj <= x0 + d` with `d <= 0`
 * for each input `xj`.
 *
 * As all inferred bounds can be related directly to a path in the source code
 * the only source of non-termination is if successive redundant (and thereby
 * increasingly worse) bounds are calculated along a loop in the source code.
 * We prevent this by weakening the bound to a small finite set of bounds when
 * a path follows a second back-edge (we postpone weakening till the second
 * back-edge as a precise bound might require traversing a loop once).
 */

import java
private import SSA
private import RangeUtils
private import semmle.code.java.dataflow.internal.rangeanalysis.SsaReadPositionCommon
private import semmle.code.java.controlflow.internal.GuardsLogic
private import SignAnalysis
private import ModulusAnalysis
private import semmle.code.java.Reflection
private import semmle.code.java.Collections
private import semmle.code.java.Maps
import Bound

cached
private module RangeAnalysisCache {
  cached
  module RangeAnalysisPublic {
    /**
     * Holds if `b + delta` is a valid bound for `e`.
     * - `upper = true`  : `e <= b + delta`
     * - `upper = false` : `e >= b + delta`
     *
     * The reason for the bound is given by `reason` and may be either a condition
     * or `NoReason` if the bound was proven directly without the use of a bounding
     * condition.
     */
    cached
    predicate bounded(Expr e, Bound b, int delta, boolean upper, Reason reason) {
      bounded(e, b, delta, upper, _, _, reason) and
      bestBound(e, b, delta, upper)
    }
  }

  /**
   * Holds if `guard = boundFlowCond(_, _, _, _, _) or guard = eqFlowCond(_, _, _, _, _)`.
   */
  cached
  predicate possibleReason(Guard guard) {
    guard = boundFlowCond(_, _, _, _, _) or guard = eqFlowCond(_, _, _, _, _)
  }
}

private import RangeAnalysisCache
import RangeAnalysisPublic

/**
 * Holds if `b + delta` is a valid bound for `e` and this is the best such delta.
 * - `upper = true`  : `e <= b + delta`
 * - `upper = false` : `e >= b + delta`
 */
private predicate bestBound(Expr e, Bound b, int delta, boolean upper) {
  delta = min(int d | bounded(e, b, d, upper, _, _, _)) and upper = true
  or
  delta = max(int d | bounded(e, b, d, upper, _, _, _)) and upper = false
}

/**
 * Holds if `comp` corresponds to:
 * - `upper = true`  : `v <= e + delta` or `v < e + delta`
 * - `upper = false` : `v >= e + delta` or `v > e + delta`
 */
private predicate boundCondition(
  ComparisonExpr comp, SsaVariable v, Expr e, int delta, boolean upper
) {
  comp.getLesserOperand() = ssaRead(v, delta) and e = comp.getGreaterOperand() and upper = true
  or
  comp.getGreaterOperand() = ssaRead(v, delta) and e = comp.getLesserOperand() and upper = false
  or
  exists(SubExpr sub, ConstantIntegerExpr c, int d |
    // (v - d) - e < c
    comp.getLesserOperand() = sub and
    comp.getGreaterOperand() = c and
    sub.getLeftOperand() = ssaRead(v, d) and
    sub.getRightOperand() = e and
    upper = true and
    delta = d + c.getIntValue()
    or
    // (v - d) - e > c
    comp.getGreaterOperand() = sub and
    comp.getLesserOperand() = c and
    sub.getLeftOperand() = ssaRead(v, d) and
    sub.getRightOperand() = e and
    upper = false and
    delta = d + c.getIntValue()
    or
    // e - (v - d) < c
    comp.getLesserOperand() = sub and
    comp.getGreaterOperand() = c and
    sub.getLeftOperand() = e and
    sub.getRightOperand() = ssaRead(v, d) and
    upper = false and
    delta = d - c.getIntValue()
    or
    // e - (v - d) > c
    comp.getGreaterOperand() = sub and
    comp.getLesserOperand() = c and
    sub.getLeftOperand() = e and
    sub.getRightOperand() = ssaRead(v, d) and
    upper = true and
    delta = d - c.getIntValue()
  )
}

/**
 * Holds if `comp` is a comparison between `x` and `y` for which `y - x` has a
 * fixed value modulo some `mod > 1`, such that the comparison can be
 * strengthened by `strengthen` when evaluating to `testIsTrue`.
 */
private predicate modulusComparison(ComparisonExpr comp, boolean testIsTrue, int strengthen) {
  exists(
    Bound b, int v1, int v2, int mod1, int mod2, int mod, boolean resultIsStrict, int d, int k
  |
    // If `x <= y` and `x =(mod) b + v1` and `y =(mod) b + v2` then
    // `0 <= y - x =(mod) v2 - v1`. By choosing `k =(mod) v2 - v1` with
    // `0 <= k < mod` we get `k <= y - x`. If the resulting comparison is
    // strict then the strengthening amount is instead `k - 1` modulo `mod`:
    // `x < y` means `0 <= y - x - 1 =(mod) k - 1` so `k - 1 <= y - x - 1` and
    // thus `k - 1 < y - x` with `0 <= k - 1 < mod`.
    exprModulus(comp.getLesserOperand(), b, v1, mod1) and
    exprModulus(comp.getGreaterOperand(), b, v2, mod2) and
    mod = mod1.gcd(mod2) and
    mod != 1 and
    (testIsTrue = true or testIsTrue = false) and
    (
      if comp.isStrict()
      then resultIsStrict = testIsTrue
      else resultIsStrict = testIsTrue.booleanNot()
    ) and
    (
      resultIsStrict = true and d = 1
      or
      resultIsStrict = false and d = 0
    ) and
    (
      testIsTrue = true and k = v2 - v1
      or
      testIsTrue = false and k = v1 - v2
    ) and
    strengthen = (((k - d) % mod) + mod) % mod
  )
}

/**
 * Gets a condition that tests whether `v` is bounded by `e + delta`.
 *
 * If the condition evaluates to `testIsTrue`:
 * - `upper = true`  : `v <= e + delta`
 * - `upper = false` : `v >= e + delta`
 */
private Guard boundFlowCond(SsaVariable v, Expr e, int delta, boolean upper, boolean testIsTrue) {
  exists(
    ComparisonExpr comp, int d1, int d2, int d3, int strengthen, boolean compIsUpper,
    boolean resultIsStrict
  |
    comp = result and
    boundCondition(comp, v, e, d1, compIsUpper) and
    (testIsTrue = true or testIsTrue = false) and
    upper = compIsUpper.booleanXor(testIsTrue.booleanNot()) and
    (
      if comp.isStrict()
      then resultIsStrict = testIsTrue
      else resultIsStrict = testIsTrue.booleanNot()
    ) and
    (
      if v.getSourceVariable().getType() instanceof IntegralType
      then
        upper = true and strengthen = -1
        or
        upper = false and strengthen = 1
      else strengthen = 0
    ) and
    (
      exists(int k | modulusComparison(comp, testIsTrue, k) and d2 = strengthen * k)
      or
      not modulusComparison(comp, testIsTrue, _) and d2 = 0
    ) and
    // A strict inequality `x < y` can be strengthened to `x <= y - 1`.
    (
      resultIsStrict = true and d3 = strengthen
      or
      resultIsStrict = false and d3 = 0
    ) and
    delta = d1 + d2 + d3
  )
  or
  exists(boolean testIsTrue0 |
    implies_v2(result, testIsTrue, boundFlowCond(v, e, delta, upper, testIsTrue0), testIsTrue0)
  )
  or
  result = eqFlowCond(v, e, delta, true, testIsTrue) and
  (upper = true or upper = false)
  or
  // guard that tests whether `v2` is bounded by `e + delta + d1 - d2` and
  // exists a guard `guardEq` such that `v = v2 - d1 + d2`.
  exists(SsaVariable v2, Guard guardEq, boolean eqIsTrue, int d1, int d2 |
    guardEq = eqFlowCond(v, ssaRead(v2, d1), d2, true, eqIsTrue) and
    result = boundFlowCond(v2, e, delta + d1 - d2, upper, testIsTrue) and
    // guardEq needs to control guard
    guardEq.directlyControls(result.getBasicBlock(), eqIsTrue)
  )
}

private newtype TReason =
  TNoReason() or
  TCondReason(Guard guard) { possibleReason(guard) }

/**
 * A reason for an inferred bound. This can either be `CondReason` if the bound
 * is due to a specific condition, or `NoReason` if the bound is inferred
 * without going through a bounding condition.
 */
abstract class Reason extends TReason {
  /** Gets a textual representation of this reason. */
  abstract string toString();
}

/**
 * A reason for an inferred bound that indicates that the bound is inferred
 * without going through a bounding condition.
 */
class NoReason extends Reason, TNoReason {
  override string toString() { result = "NoReason" }
}

/** A reason for an inferred bound pointing to a condition. */
class CondReason extends Reason, TCondReason {
  /** Gets the condition that is the reason for the bound. */
  Guard getCond() { this = TCondReason(result) }

  override string toString() { result = getCond().toString() }
}

/**
 * Holds if `e + delta` is a valid bound for `v` at `pos`.
 * - `upper = true`  : `v <= e + delta`
 * - `upper = false` : `v >= e + delta`
 */
private predicate boundFlowStepSsa(
  SsaVariable v, SsaReadPosition pos, Expr e, int delta, boolean upper, Reason reason
) {
  ssaUpdateStep(v, e, delta) and
  pos.hasReadOfVar(v) and
  (upper = true or upper = false) and
  reason = TNoReason()
  or
  exists(Guard guard, boolean testIsTrue |
    pos.hasReadOfVar(v) and
    guard = boundFlowCond(v, e, delta, upper, testIsTrue) and
    guardDirectlyControlsSsaRead(guard, pos, testIsTrue) and
    reason = TCondReason(guard)
  )
}

/** Holds if `v != e + delta` at `pos` and `v` is of integral type. */
private predicate unequalFlowStepIntegralSsa(
  SsaVariable v, SsaReadPosition pos, Expr e, int delta, Reason reason
) {
  v.getSourceVariable().getType() instanceof IntegralType and
  exists(Guard guard, boolean testIsTrue |
    pos.hasReadOfVar(v) and
    guard = eqFlowCond(v, e, delta, false, testIsTrue) and
    guardDirectlyControlsSsaRead(guard, pos, testIsTrue) and
    reason = TCondReason(guard)
  )
}

/**
 * Holds if a cast from `fromtyp` to `totyp` can be ignored for the purpose of
 * range analysis.
 */
private predicate safeCast(Type fromtyp, Type totyp) {
  exists(PrimitiveType pfrom, PrimitiveType pto | pfrom = fromtyp and pto = totyp |
    pfrom = pto
    or
    pfrom.hasName("char") and pto.getName().regexpMatch("int|long|float|double")
    or
    pfrom.hasName("byte") and pto.getName().regexpMatch("short|int|long|float|double")
    or
    pfrom.hasName("short") and pto.getName().regexpMatch("int|long|float|double")
    or
    pfrom.hasName("int") and pto.getName().regexpMatch("long|float|double")
    or
    pfrom.hasName("long") and pto.getName().regexpMatch("float|double")
    or
    pfrom.hasName("float") and pto.hasName("double")
    or
    pfrom.hasName("double") and pto.hasName("float")
  )
  or
  safeCast(fromtyp.(BoxedType).getPrimitiveType(), totyp)
  or
  safeCast(fromtyp, totyp.(BoxedType).getPrimitiveType())
}

/**
 * A cast that can be ignored for the purpose of range analysis.
 */
private class SafeCastExpr extends CastExpr {
  SafeCastExpr() { safeCast(getExpr().getType(), getType()) }
}

/**
 * Holds if `typ` is a small integral type with the given lower and upper bounds.
 */
private predicate typeBound(Type typ, int lowerbound, int upperbound) {
  typ.(PrimitiveType).hasName("byte") and lowerbound = -128 and upperbound = 127
  or
  typ.(PrimitiveType).hasName("short") and lowerbound = -32768 and upperbound = 32767
  or
  typ.(PrimitiveType).hasName("char") and lowerbound = 0 and upperbound = 65535
  or
  typeBound(typ.(BoxedType).getPrimitiveType(), lowerbound, upperbound)
}

/**
 * A cast to a small integral type that may overflow or underflow.
 */
private class NarrowingCastExpr extends CastExpr {
  NarrowingCastExpr() {
    not this instanceof SafeCastExpr and
    typeBound(getType(), _, _)
  }

  /** Gets the lower bound of the resulting type. */
  int getLowerBound() { typeBound(getType(), result, _) }

  /** Gets the upper bound of the resulting type. */
  int getUpperBound() { typeBound(getType(), _, result) }
}

/** Holds if `e >= 1` as determined by sign analysis. */
private predicate strictlyPositiveIntegralExpr(Expr e) {
  strictlyPositive(e) and e.getType() instanceof IntegralType
}

/** Holds if `e <= -1` as determined by sign analysis. */
private predicate strictlyNegativeIntegralExpr(Expr e) {
  strictlyNegative(e) and e.getType() instanceof IntegralType
}

/**
 * Holds if `e1 + delta` is a valid bound for `e2`.
 * - `upper = true`  : `e2 <= e1 + delta`
 * - `upper = false` : `e2 >= e1 + delta`
 */
private predicate boundFlowStep(Expr e2, Expr e1, int delta, boolean upper) {
  valueFlowStep(e2, e1, delta) and
  (upper = true or upper = false)
  or
  e2.(SafeCastExpr).getExpr() = e1 and
  delta = 0 and
  (upper = true or upper = false)
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
    // `x instanceof ConstantIntegerExpr` is covered by valueFlowStep
    not x instanceof ConstantIntegerExpr and
    not e1 instanceof ConstantIntegerExpr and
    if strictlyPositiveIntegralExpr(x)
    then upper = false and delta = 1
    else
      if positive(x)
      then upper = false and delta = 0
      else
        if strictlyNegativeIntegralExpr(x)
        then upper = true and delta = -1
        else
          if negative(x)
          then upper = true and delta = 0
          else none()
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
    // `x instanceof ConstantIntegerExpr` is covered by valueFlowStep
    not x instanceof ConstantIntegerExpr and
    if strictlyPositiveIntegralExpr(x)
    then upper = true and delta = -1
    else
      if positive(x)
      then upper = true and delta = 0
      else
        if strictlyNegativeIntegralExpr(x)
        then upper = false and delta = 1
        else
          if negative(x)
          then upper = false and delta = 0
          else none()
  )
  or
  e2.(RemExpr).getRightOperand() = e1 and positive(e1) and delta = -1 and upper = true
  or
  e2.(RemExpr).getLeftOperand() = e1 and positive(e1) and delta = 0 and upper = true
  or
  e2.(AssignRemExpr).getRhs() = e1 and positive(e1) and delta = -1 and upper = true
  or
  e2.(AssignRemExpr).getDest() = e1 and positive(e1) and delta = 0 and upper = true
  or
  e2.(AndBitwiseExpr).getAnOperand() = e1 and positive(e1) and delta = 0 and upper = true
  or
  e2.(AssignAndExpr).getSource() = e1 and positive(e1) and delta = 0 and upper = true
  or
  e2.(OrBitwiseExpr).getAnOperand() = e1 and positive(e2) and delta = 0 and upper = false
  or
  e2.(AssignOrExpr).getSource() = e1 and positive(e2) and delta = 0 and upper = false
  or
  exists(MethodAccess ma, Method m |
    e2 = ma and
    ma.getMethod() = m and
    m.hasName("nextInt") and
    m.getDeclaringType().hasQualifiedName("java.util", "Random") and
    e1 = ma.getAnArgument() and
    delta = -1 and
    upper = true
  )
  or
  exists(MethodAccess ma, Method m |
    e2 = ma and
    ma.getMethod() = m and
    (
      m.hasName("max") and upper = false
      or
      m.hasName("min") and upper = true
    ) and
    m.getDeclaringType().hasQualifiedName("java.lang", "Math") and
    e1 = ma.getAnArgument() and
    delta = 0
  )
}

/** Holds if `e2 = e1 * factor` and `factor > 0`. */
private predicate boundFlowStepMul(Expr e2, Expr e1, int factor) {
  exists(ConstantIntegerExpr c, int k | k = c.getIntValue() and k > 0 |
    e2.(MulExpr).hasOperands(e1, c) and factor = k
    or
    exists(AssignMulExpr e | e = e2 and e.getDest() = e1 and e.getRhs() = c and factor = k)
    or
    exists(AssignMulExpr e | e = e2 and e.getDest() = c and e.getRhs() = e1 and factor = k)
    or
    exists(LShiftExpr e |
      e = e2 and e.getLeftOperand() = e1 and e.getRightOperand() = c and factor = 2.pow(k)
    )
    or
    exists(AssignLShiftExpr e |
      e = e2 and e.getDest() = e1 and e.getRhs() = c and factor = 2.pow(k)
    )
  )
}

/**
 * Holds if `e2 = e1 / factor` and `factor > 0`.
 *
 * This conflates division, right shift, and unsigned right shift and is
 * therefore only valid for non-negative numbers.
 */
private predicate boundFlowStepDiv(Expr e2, Expr e1, int factor) {
  exists(ConstantIntegerExpr c, int k | k = c.getIntValue() and k > 0 |
    exists(DivExpr e |
      e = e2 and e.getLeftOperand() = e1 and e.getRightOperand() = c and factor = k
    )
    or
    exists(AssignDivExpr e | e = e2 and e.getDest() = e1 and e.getRhs() = c and factor = k)
    or
    exists(RShiftExpr e |
      e = e2 and e.getLeftOperand() = e1 and e.getRightOperand() = c and factor = 2.pow(k)
    )
    or
    exists(AssignRShiftExpr e |
      e = e2 and e.getDest() = e1 and e.getRhs() = c and factor = 2.pow(k)
    )
    or
    exists(URShiftExpr e |
      e = e2 and e.getLeftOperand() = e1 and e.getRightOperand() = c and factor = 2.pow(k)
    )
    or
    exists(AssignURShiftExpr e |
      e = e2 and e.getDest() = e1 and e.getRhs() = c and factor = 2.pow(k)
    )
  )
}

/**
 * Holds if `b + delta` is a valid bound for `v` at `pos`.
 * - `upper = true`  : `v <= b + delta`
 * - `upper = false` : `v >= b + delta`
 */
private predicate boundedSsa(
  SsaVariable v, SsaReadPosition pos, Bound b, int delta, boolean upper, boolean fromBackEdge,
  int origdelta, Reason reason
) {
  exists(Expr mid, int d1, int d2, Reason r1, Reason r2 |
    boundFlowStepSsa(v, pos, mid, d1, upper, r1) and
    bounded(mid, b, d2, upper, fromBackEdge, origdelta, r2) and
    // upper = true:  v <= mid + d1 <= b + d1 + d2 = b + delta
    // upper = false: v >= mid + d1 >= b + d1 + d2 = b + delta
    delta = d1 + d2 and
    (if r1 instanceof NoReason then reason = r2 else reason = r1)
  )
  or
  exists(int d, Reason r1, Reason r2 |
    boundedSsa(v, pos, b, d, upper, fromBackEdge, origdelta, r2) or
    boundedPhi(v, b, d, upper, fromBackEdge, origdelta, r2)
  |
    unequalIntegralSsa(v, pos, b, d, r1) and
    (
      upper = true and delta = d - 1
      or
      upper = false and delta = d + 1
    ) and
    (
      reason = r1
      or
      reason = r2 and not r2 instanceof NoReason
    )
  )
}

/**
 * Holds if `v != b + delta` at `pos` and `v` is of integral type.
 */
private predicate unequalIntegralSsa(
  SsaVariable v, SsaReadPosition pos, Bound b, int delta, Reason reason
) {
  exists(Expr e, int d1, int d2 |
    unequalFlowStepIntegralSsa(v, pos, e, d1, reason) and
    bounded(e, b, d2, true, _, _, _) and
    bounded(e, b, d2, false, _, _, _) and
    delta = d2 + d1
  )
}

/** Weakens a delta to lie in the range `[-1..1]`. */
bindingset[delta, upper]
private int weakenDelta(boolean upper, int delta) {
  delta in [-1 .. 1] and result = delta
  or
  upper = true and result = -1 and delta < -1
  or
  upper = false and result = 1 and delta > 1
}

/**
 * Holds if `b + delta` is a valid bound for `inp` when used as an input to
 * `phi` along `edge`.
 * - `upper = true`  : `inp <= b + delta`
 * - `upper = false` : `inp >= b + delta`
 */
private predicate boundedPhiInp(
  SsaPhiNode phi, SsaVariable inp, SsaReadPositionPhiInputEdge edge, Bound b, int delta,
  boolean upper, boolean fromBackEdge, int origdelta, Reason reason
) {
  edge.phiInput(phi, inp) and
  exists(int d, boolean fromBackEdge0 |
    boundedSsa(inp, edge, b, d, upper, fromBackEdge0, origdelta, reason)
    or
    boundedPhi(inp, b, d, upper, fromBackEdge0, origdelta, reason)
    or
    b.(SsaBound).getSsa() = inp and
    d = 0 and
    (upper = true or upper = false) and
    fromBackEdge0 = false and
    origdelta = 0 and
    reason = TNoReason()
  |
    if backEdge(phi, inp, edge)
    then
      fromBackEdge = true and
      (
        fromBackEdge0 = true and delta = weakenDelta(upper, d - origdelta) + origdelta
        or
        fromBackEdge0 = false and delta = d
      )
    else (
      delta = d and fromBackEdge = fromBackEdge0
    )
  )
}

/** Holds if `boundedPhiInp(phi, inp, edge, b, delta, upper, _, _, _)`. */
pragma[noinline]
private predicate boundedPhiInp1(
  SsaPhiNode phi, Bound b, boolean upper, SsaVariable inp, SsaReadPositionPhiInputEdge edge,
  int delta
) {
  boundedPhiInp(phi, inp, edge, b, delta, upper, _, _, _)
}

/**
 * Holds if `phi` is a valid bound for `inp` when used as an input to `phi`
 * along `edge`.
 * - `upper = true`  : `inp <= phi`
 * - `upper = false` : `inp >= phi`
 */
private predicate selfBoundedPhiInp(
  SsaPhiNode phi, SsaVariable inp, SsaReadPositionPhiInputEdge edge, boolean upper
) {
  exists(int d, SsaBound phibound |
    phibound.getSsa() = phi and
    boundedPhiInp(phi, inp, edge, phibound, d, upper, _, _, _) and
    (
      upper = true and d <= 0
      or
      upper = false and d >= 0
    )
  )
}

/**
 * Holds if `b + delta` is a valid bound for some input, `inp`, to `phi`, and
 * thus a candidate bound for `phi`.
 * - `upper = true`  : `inp <= b + delta`
 * - `upper = false` : `inp >= b + delta`
 */
pragma[noinline]
private predicate boundedPhiCand(
  SsaPhiNode phi, boolean upper, Bound b, int delta, boolean fromBackEdge, int origdelta,
  Reason reason
) {
  exists(SsaVariable inp, SsaReadPositionPhiInputEdge edge |
    boundedPhiInp(phi, inp, edge, b, delta, upper, fromBackEdge, origdelta, reason)
  )
}

/**
 * Holds if the candidate bound `b + delta` for `phi` is valid for the phi input
 * `inp` along `edge`.
 */
private predicate boundedPhiCandValidForEdge(
  SsaPhiNode phi, Bound b, int delta, boolean upper, boolean fromBackEdge, int origdelta,
  Reason reason, SsaVariable inp, SsaReadPositionPhiInputEdge edge
) {
  boundedPhiCand(phi, upper, b, delta, fromBackEdge, origdelta, reason) and
  (
    exists(int d | boundedPhiInp1(phi, b, upper, inp, edge, d) | upper = true and d <= delta)
    or
    exists(int d | boundedPhiInp1(phi, b, upper, inp, edge, d) | upper = false and d >= delta)
    or
    selfBoundedPhiInp(phi, inp, edge, upper)
  )
}

/**
 * Holds if `b + delta` is a valid bound for `phi`.
 * - `upper = true`  : `phi <= b + delta`
 * - `upper = false` : `phi >= b + delta`
 */
private predicate boundedPhi(
  SsaPhiNode phi, Bound b, int delta, boolean upper, boolean fromBackEdge, int origdelta,
  Reason reason
) {
  forex(SsaVariable inp, SsaReadPositionPhiInputEdge edge | edge.phiInput(phi, inp) |
    boundedPhiCandValidForEdge(phi, b, delta, upper, fromBackEdge, origdelta, reason, inp, edge)
  )
}

/**
 * Holds if `e` has a lower bound of zero.
 */
private predicate lowerBoundZero(Expr e) {
  e.(MethodAccess).getMethod() instanceof StringLengthMethod or
  e.(MethodAccess).getMethod() instanceof CollectionSizeMethod or
  e.(MethodAccess).getMethod() instanceof MapSizeMethod or
  e.(FieldRead).getField() instanceof ArrayLengthField or
  positive(e.(AndBitwiseExpr).getAnOperand())
}

/**
 * Holds if `e` has an upper (for `upper = true`) or lower
 * (for `upper = false`) bound of `b`.
 */
private predicate baseBound(Expr e, int b, boolean upper) {
  lowerBoundZero(e) and b = 0 and upper = false
  or
  exists(Method read |
    e.(MethodAccess).getMethod().overrides*(read) and
    read.getDeclaringType().hasQualifiedName("java.io", "InputStream") and
    read.hasName("read") and
    read.getNumberOfParameters() = 0
  |
    upper = true and b = 255
    or
    upper = false and b = -1
  )
}

/**
 * Holds if the value being cast has an upper (for `upper = true`) or lower
 * (for `upper = false`) bound within the bounds of the resulting type.
 * For `upper = true` this means that the cast will not overflow and for
 * `upper = false` this means that the cast will not underflow.
 */
private predicate safeNarrowingCast(NarrowingCastExpr cast, boolean upper) {
  exists(int bound | bounded(cast.getExpr(), any(ZeroBound zb), bound, upper, _, _, _) |
    upper = true and bound <= cast.getUpperBound()
    or
    upper = false and bound >= cast.getLowerBound()
  )
}

pragma[noinline]
private predicate boundedCastExpr(
  NarrowingCastExpr cast, Bound b, int delta, boolean upper, boolean fromBackEdge, int origdelta,
  Reason reason
) {
  bounded(cast.getExpr(), b, delta, upper, fromBackEdge, origdelta, reason)
}

/**
 * Holds if `b + delta` is a valid bound for `e`.
 * - `upper = true`  : `e <= b + delta`
 * - `upper = false` : `e >= b + delta`
 */
private predicate bounded(
  Expr e, Bound b, int delta, boolean upper, boolean fromBackEdge, int origdelta, Reason reason
) {
  e = b.getExpr(delta) and
  (upper = true or upper = false) and
  fromBackEdge = false and
  origdelta = delta and
  reason = TNoReason()
  or
  baseBound(e, delta, upper) and
  b instanceof ZeroBound and
  fromBackEdge = false and
  origdelta = delta and
  reason = TNoReason()
  or
  exists(SsaVariable v, SsaReadPositionBlock bb |
    boundedSsa(v, bb, b, delta, upper, fromBackEdge, origdelta, reason) and
    e = v.getAUse() and
    bb.getBlock() = e.getBasicBlock()
  )
  or
  exists(Expr mid, int d1, int d2 |
    boundFlowStep(e, mid, d1, upper) and
    // Constants have easy, base-case bounds, so let's not infer any recursive bounds.
    not e instanceof ConstantIntegerExpr and
    bounded(mid, b, d2, upper, fromBackEdge, origdelta, reason) and
    // upper = true:  e <= mid + d1 <= b + d1 + d2 = b + delta
    // upper = false: e >= mid + d1 >= b + d1 + d2 = b + delta
    delta = d1 + d2
  )
  or
  exists(SsaPhiNode phi |
    boundedPhi(phi, b, delta, upper, fromBackEdge, origdelta, reason) and
    e = phi.getAUse()
  )
  or
  exists(Expr mid, int factor, int d |
    boundFlowStepMul(e, mid, factor) and
    not e instanceof ConstantIntegerExpr and
    bounded(mid, b, d, upper, fromBackEdge, origdelta, reason) and
    b instanceof ZeroBound and
    delta = d * factor
  )
  or
  exists(Expr mid, int factor, int d |
    boundFlowStepDiv(e, mid, factor) and
    not e instanceof ConstantIntegerExpr and
    bounded(mid, b, d, upper, fromBackEdge, origdelta, reason) and
    b instanceof ZeroBound and
    d >= 0 and
    delta = d / factor
  )
  or
  exists(NarrowingCastExpr cast |
    cast = e and
    safeNarrowingCast(cast, upper.booleanNot()) and
    boundedCastExpr(cast, b, delta, upper, fromBackEdge, origdelta, reason)
  )
  or
  exists(
    ConditionalExpr cond, int d1, int d2, boolean fbe1, boolean fbe2, int od1, int od2, Reason r1,
    Reason r2
  |
    cond = e and
    boundedConditionalExpr(cond, b, upper, true, d1, fbe1, od1, r1) and
    boundedConditionalExpr(cond, b, upper, false, d2, fbe2, od2, r2) and
    (
      delta = d1 and fromBackEdge = fbe1 and origdelta = od1 and reason = r1
      or
      delta = d2 and fromBackEdge = fbe2 and origdelta = od2 and reason = r2
    )
  |
    upper = true and delta = d1.maximum(d2)
    or
    upper = false and delta = d1.minimum(d2)
  )
}

private predicate boundedConditionalExpr(
  ConditionalExpr cond, Bound b, boolean upper, boolean branch, int delta, boolean fromBackEdge,
  int origdelta, Reason reason
) {
  branch = true and bounded(cond.getTrueExpr(), b, delta, upper, fromBackEdge, origdelta, reason)
  or
  branch = false and bounded(cond.getFalseExpr(), b, delta, upper, fromBackEdge, origdelta, reason)
}
