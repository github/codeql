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

private import RangeAnalysisSpecific as Specific
private import RangeUtils
private import SignAnalysisCommon
private import ModulusAnalysis
private import experimental.semmle.code.cpp.semantic.Semantic
private import ConstantAnalysis

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
    predicate semBounded(SemExpr e, SemBound b, int delta, boolean upper, SemReason reason) {
      bounded(e, b, delta, upper, _, _, reason) and
      bestBound(e, b, delta, upper)
    }
  }

  /**
   * Holds if `guard = boundFlowCond(_, _, _, _, _) or guard = eqFlowCond(_, _, _, _, _)`.
   */
  cached
  predicate possibleReason(SemGuard guard) {
    guard = boundFlowCond(_, _, _, _, _) or guard = semEqFlowCond(_, _, _, _, _)
  }
}

private import RangeAnalysisCache
import RangeAnalysisPublic

/**
 * Holds if `b + delta` is a valid bound for `e` and this is the best such delta.
 * - `upper = true`  : `e <= b + delta`
 * - `upper = false` : `e >= b + delta`
 */
private predicate bestBound(SemExpr e, SemBound b, int delta, boolean upper) {
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
  SemRelationalExpr comp, SemSsaVariable v, SemExpr e, int delta, boolean upper
) {
  comp.getLesserOperand() = semSsaRead(v, delta) and e = comp.getGreaterOperand() and upper = true
  or
  comp.getGreaterOperand() = semSsaRead(v, delta) and e = comp.getLesserOperand() and upper = false
  or
  exists(SemSubExpr sub, SemConstantIntegerExpr c, int d |
    // (v - d) - e < c
    comp.getLesserOperand() = sub and
    comp.getGreaterOperand() = c and
    sub.getLeftOperand() = semSsaRead(v, d) and
    sub.getRightOperand() = e and
    upper = true and
    delta = d + c.getIntValue()
    or
    // (v - d) - e > c
    comp.getGreaterOperand() = sub and
    comp.getLesserOperand() = c and
    sub.getLeftOperand() = semSsaRead(v, d) and
    sub.getRightOperand() = e and
    upper = false and
    delta = d + c.getIntValue()
    or
    // e - (v - d) < c
    comp.getLesserOperand() = sub and
    comp.getGreaterOperand() = c and
    sub.getLeftOperand() = e and
    sub.getRightOperand() = semSsaRead(v, d) and
    upper = false and
    delta = d - c.getIntValue()
    or
    // e - (v - d) > c
    comp.getGreaterOperand() = sub and
    comp.getLesserOperand() = c and
    sub.getLeftOperand() = e and
    sub.getRightOperand() = semSsaRead(v, d) and
    upper = true and
    delta = d - c.getIntValue()
  )
}

/**
 * Holds if `comp` is a comparison between `x` and `y` for which `y - x` has a
 * fixed value modulo some `mod > 1`, such that the comparison can be
 * strengthened by `strengthen` when evaluating to `testIsTrue`.
 */
private predicate modulusComparison(SemRelationalExpr comp, boolean testIsTrue, int strengthen) {
  exists(
    SemBound b, int v1, int v2, int mod1, int mod2, int mod, boolean resultIsStrict, int d, int k
  |
    // If `x <= y` and `x =(mod) b + v1` and `y =(mod) b + v2` then
    // `0 <= y - x =(mod) v2 - v1`. By choosing `k =(mod) v2 - v1` with
    // `0 <= k < mod` we get `k <= y - x`. If the resulting comparison is
    // strict then the strengthening amount is instead `k - 1` modulo `mod`:
    // `x < y` means `0 <= y - x - 1 =(mod) k - 1` so `k - 1 <= y - x - 1` and
    // thus `k - 1 < y - x` with `0 <= k - 1 < mod`.
    semExprModulus(comp.getLesserOperand(), b, v1, mod1) and
    semExprModulus(comp.getGreaterOperand(), b, v2, mod2) and
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
private SemGuard boundFlowCond(
  SemSsaVariable v, SemExpr e, int delta, boolean upper, boolean testIsTrue
) {
  exists(
    SemRelationalExpr comp, int d1, int d2, int d3, int strengthen, boolean compIsUpper,
    boolean resultIsStrict
  |
    comp = result.asExpr() and
    boundCondition(comp, v, e, d1, compIsUpper) and
    (testIsTrue = true or testIsTrue = false) and
    upper = compIsUpper.booleanXor(testIsTrue.booleanNot()) and
    (
      if comp.isStrict()
      then resultIsStrict = testIsTrue
      else resultIsStrict = testIsTrue.booleanNot()
    ) and
    (
      if getTrackedTypeForSsaVariable(v) instanceof SemIntegerType
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
    semImplies_v2(result, testIsTrue, boundFlowCond(v, e, delta, upper, testIsTrue0), testIsTrue0)
  )
  or
  result = semEqFlowCond(v, e, delta, true, testIsTrue) and
  (upper = true or upper = false)
  or
  // guard that tests whether `v2` is bounded by `e + delta + d1 - d2` and
  // exists a guard `guardEq` such that `v = v2 - d1 + d2`.
  exists(SemSsaVariable v2, SemGuard guardEq, boolean eqIsTrue, int d1, int d2 |
    guardEq = semEqFlowCond(v, semSsaRead(v2, d1), d2, true, eqIsTrue) and
    result = boundFlowCond(v2, e, delta + d1 - d2, upper, testIsTrue) and
    // guardEq needs to control guard
    guardEq.directlyControls(result.getBasicBlock(), eqIsTrue)
  )
}

private newtype TSemReason =
  TSemNoReason() or
  TSemCondReason(SemGuard guard) { possibleReason(guard) }

/**
 * A reason for an inferred bound. This can either be `CondReason` if the bound
 * is due to a specific condition, or `NoReason` if the bound is inferred
 * without going through a bounding condition.
 */
abstract class SemReason extends TSemReason {
  /** Gets a textual representation of this reason. */
  abstract string toString();
}

/**
 * A reason for an inferred bound that indicates that the bound is inferred
 * without going through a bounding condition.
 */
class SemNoReason extends SemReason, TSemNoReason {
  override string toString() { result = "NoReason" }
}

/** A reason for an inferred bound pointing to a condition. */
class SemCondReason extends SemReason, TSemCondReason {
  /** Gets the condition that is the reason for the bound. */
  SemGuard getCond() { this = TSemCondReason(result) }

  override string toString() { result = getCond().toString() }
}

/**
 * Holds if `e + delta` is a valid bound for `v` at `pos`.
 * - `upper = true`  : `v <= e + delta`
 * - `upper = false` : `v >= e + delta`
 */
private predicate boundFlowStepSsa(
  SemSsaVariable v, SemSsaReadPosition pos, SemExpr e, int delta, boolean upper, SemReason reason
) {
  semSsaUpdateStep(v, e, delta) and
  pos.hasReadOfVar(v) and
  (upper = true or upper = false) and
  reason = TSemNoReason()
  or
  exists(SemGuard guard, boolean testIsTrue |
    pos.hasReadOfVar(v) and
    guard = boundFlowCond(v, e, delta, upper, testIsTrue) and
    semGuardDirectlyControlsSsaRead(guard, pos, testIsTrue) and
    reason = TSemCondReason(guard)
  )
}

/** Holds if `v != e + delta` at `pos` and `v` is of integral type. */
private predicate unequalFlowStepIntegralSsa(
  SemSsaVariable v, SemSsaReadPosition pos, SemExpr e, int delta, SemReason reason
) {
  getTrackedTypeForSsaVariable(v) instanceof SemIntegerType and
  exists(SemGuard guard, boolean testIsTrue |
    pos.hasReadOfVar(v) and
    guard = semEqFlowCond(v, e, delta, false, testIsTrue) and
    semGuardDirectlyControlsSsaRead(guard, pos, testIsTrue) and
    reason = TSemCondReason(guard)
  )
}

/**
 * An expression that does conversion, boxing, or unboxing
 */
private class ConvertOrBoxExpr extends SemUnaryExpr {
  ConvertOrBoxExpr() {
    this instanceof SemConvertExpr
    or
    this instanceof SemBoxExpr
    or
    this instanceof SemUnboxExpr
  }
}

/**
 * A cast that can be ignored for the purpose of range analysis.
 */
private class SafeCastExpr extends ConvertOrBoxExpr {
  SafeCastExpr() { conversionCannotOverflow(getTrackedType(getOperand()), getTrackedType(this)) }
}

/**
 * Holds if `typ` is a small integral type with the given lower and upper bounds.
 */
private predicate typeBound(SemIntegerType typ, int lowerbound, int upperbound) {
  exists(int bitSize | bitSize = typ.getByteSize() * 8 |
    bitSize < 32 and
    (
      if typ.isSigned()
      then (
        upperbound = 1.bitShiftLeft(bitSize - 1) - 1 and
        lowerbound = -upperbound - 1
      ) else (
        lowerbound = 0 and
        upperbound = 1.bitShiftLeft(bitSize) - 1
      )
    )
  )
}

/**
 * A cast to a small integral type that may overflow or underflow.
 */
private class NarrowingCastExpr extends ConvertOrBoxExpr {
  NarrowingCastExpr() {
    not this instanceof SafeCastExpr and
    typeBound(getTrackedType(this), _, _)
  }

  /** Gets the lower bound of the resulting type. */
  int getLowerBound() { typeBound(getTrackedType(this), result, _) }

  /** Gets the upper bound of the resulting type. */
  int getUpperBound() { typeBound(getTrackedType(this), _, result) }
}

/** Holds if `e >= 1` as determined by sign analysis. */
private predicate strictlyPositiveIntegralExpr(SemExpr e) {
  semStrictlyPositive(e) and getTrackedType(e) instanceof SemIntegerType
}

/** Holds if `e <= -1` as determined by sign analysis. */
private predicate strictlyNegativeIntegralExpr(SemExpr e) {
  semStrictlyNegative(e) and getTrackedType(e) instanceof SemIntegerType
}

/**
 * Holds if `e1 + delta` is a valid bound for `e2`.
 * - `upper = true`  : `e2 <= e1 + delta`
 * - `upper = false` : `e2 >= e1 + delta`
 */
private predicate boundFlowStep(SemExpr e2, SemExpr e1, int delta, boolean upper) {
  semValueFlowStep(e2, e1, delta) and
  (upper = true or upper = false)
  or
  e2.(SafeCastExpr).getOperand() = e1 and
  delta = 0 and
  (upper = true or upper = false)
  or
  exists(SemExpr x | e2.(SemAddExpr).hasOperands(e1, x) |
    // `x instanceof ConstantIntegerExpr` is covered by valueFlowStep
    not x instanceof SemConstantIntegerExpr and
    not e1 instanceof SemConstantIntegerExpr and
    if strictlyPositiveIntegralExpr(x)
    then upper = false and delta = 1
    else
      if semPositive(x)
      then upper = false and delta = 0
      else
        if strictlyNegativeIntegralExpr(x)
        then upper = true and delta = -1
        else
          if semNegative(x)
          then upper = true and delta = 0
          else none()
  )
  or
  exists(SemExpr x, SemSubExpr sub |
    e2 = sub and
    sub.getLeftOperand() = e1 and
    sub.getRightOperand() = x
  |
    // `x instanceof ConstantIntegerExpr` is covered by valueFlowStep
    not x instanceof SemConstantIntegerExpr and
    if strictlyPositiveIntegralExpr(x)
    then upper = true and delta = -1
    else
      if semPositive(x)
      then upper = true and delta = 0
      else
        if strictlyNegativeIntegralExpr(x)
        then upper = false and delta = 1
        else
          if semNegative(x)
          then upper = false and delta = 0
          else none()
  )
  or
  e2.(SemRemExpr).getRightOperand() = e1 and
  semPositive(e1) and
  delta = -1 and
  upper = true
  or
  e2.(SemRemExpr).getLeftOperand() = e1 and semPositive(e1) and delta = 0 and upper = true
  or
  e2.(SemBitAndExpr).getAnOperand() = e1 and
  semPositive(e1) and
  delta = 0 and
  upper = true
  or
  e2.(SemBitOrExpr).getAnOperand() = e1 and
  semPositive(e2) and
  delta = 0 and
  upper = false
  or
  Specific::hasBound(e2, e1, delta, upper)
}

/** Holds if `e2 = e1 * factor` and `factor > 0`. */
private predicate boundFlowStepMul(SemExpr e2, SemExpr e1, int factor) {
  exists(SemConstantIntegerExpr c, int k | k = c.getIntValue() and k > 0 |
    e2.(SemMulExpr).hasOperands(e1, c) and factor = k
    or
    exists(SemShiftLeftExpr e |
      e = e2 and e.getLeftOperand() = e1 and e.getRightOperand() = c and factor = 2.pow(k)
    )
  )
}

/**
 * Holds if `e2 = e1 / factor` and `factor > 0`.
 *
 * This conflates division, right shift, and unsigned right shift and is
 * therefore only valid for non-negative numbers.
 */
private predicate boundFlowStepDiv(SemExpr e2, SemExpr e1, int factor) {
  exists(SemConstantIntegerExpr c, int k | k = c.getIntValue() and k > 0 |
    exists(SemDivExpr e |
      e = e2 and e.getLeftOperand() = e1 and e.getRightOperand() = c and factor = k
    )
    or
    exists(SemShiftRightExpr e |
      e = e2 and e.getLeftOperand() = e1 and e.getRightOperand() = c and factor = 2.pow(k)
    )
    or
    exists(SemShiftRightUnsignedExpr e |
      e = e2 and e.getLeftOperand() = e1 and e.getRightOperand() = c and factor = 2.pow(k)
    )
  )
}

/**
 * Holds if `b + delta` is a valid bound for `v` at `pos`.
 * - `upper = true`  : `v <= b + delta`
 * - `upper = false` : `v >= b + delta`
 */
private predicate boundedSsa(
  SemSsaVariable v, SemSsaReadPosition pos, SemBound b, int delta, boolean upper,
  boolean fromBackEdge, int origdelta, SemReason reason
) {
  exists(SemExpr mid, int d1, int d2, SemReason r1, SemReason r2 |
    boundFlowStepSsa(v, pos, mid, d1, upper, r1) and
    bounded(mid, b, d2, upper, fromBackEdge, origdelta, r2) and
    // upper = true:  v <= mid + d1 <= b + d1 + d2 = b + delta
    // upper = false: v >= mid + d1 >= b + d1 + d2 = b + delta
    delta = d1 + d2 and
    (if r1 instanceof SemNoReason then reason = r2 else reason = r1)
  )
  or
  exists(int d, SemReason r1, SemReason r2 |
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
      reason = r2 and not r2 instanceof SemNoReason
    )
  )
}

/**
 * Holds if `v != b + delta` at `pos` and `v` is of integral type.
 */
private predicate unequalIntegralSsa(
  SemSsaVariable v, SemSsaReadPosition pos, SemBound b, int delta, SemReason reason
) {
  exists(SemExpr e, int d1, int d2 |
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
  SemSsaPhiNode phi, SemSsaVariable inp, SemSsaReadPositionPhiInputEdge edge, SemBound b, int delta,
  boolean upper, boolean fromBackEdge, int origdelta, SemReason reason
) {
  edge.phiInput(phi, inp) and
  exists(int d, boolean fromBackEdge0 |
    boundedSsa(inp, edge, b, d, upper, fromBackEdge0, origdelta, reason)
    or
    boundedPhi(inp, b, d, upper, fromBackEdge0, origdelta, reason)
    or
    b.(SemSsaBound).getAVariable() = inp and
    d = 0 and
    (upper = true or upper = false) and
    fromBackEdge0 = false and
    origdelta = 0 and
    reason = TSemNoReason()
  |
    if semBackEdge(phi, inp, edge)
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

/**
 * Holds if `b + delta` is a valid bound for `inp` when used as an input to
 * `phi` along `edge`.
 * - `upper = true`  : `inp <= b + delta`
 * - `upper = false` : `inp >= b + delta`
 *
 * Equivalent to `boundedPhiInp(phi, inp, edge, b, delta, upper, _, _, _)`.
 */
pragma[noinline]
private predicate boundedPhiInp1(
  SemSsaPhiNode phi, SemBound b, boolean upper, SemSsaVariable inp,
  SemSsaReadPositionPhiInputEdge edge, int delta
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
  SemSsaPhiNode phi, SemSsaVariable inp, SemSsaReadPositionPhiInputEdge edge, boolean upper
) {
  exists(int d, SemSsaBound phibound |
    phibound.getAVariable() = phi and
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
  SemSsaPhiNode phi, boolean upper, SemBound b, int delta, boolean fromBackEdge, int origdelta,
  SemReason reason
) {
  exists(SemSsaVariable inp, SemSsaReadPositionPhiInputEdge edge |
    boundedPhiInp(phi, inp, edge, b, delta, upper, fromBackEdge, origdelta, reason)
  )
}

/**
 * Holds if the candidate bound `b + delta` for `phi` is valid for the phi input
 * `inp` along `edge`.
 */
private predicate boundedPhiCandValidForEdge(
  SemSsaPhiNode phi, SemBound b, int delta, boolean upper, boolean fromBackEdge, int origdelta,
  SemReason reason, SemSsaVariable inp, SemSsaReadPositionPhiInputEdge edge
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
  SemSsaPhiNode phi, SemBound b, int delta, boolean upper, boolean fromBackEdge, int origdelta,
  SemReason reason
) {
  forex(SemSsaVariable inp, SemSsaReadPositionPhiInputEdge edge | edge.phiInput(phi, inp) |
    boundedPhiCandValidForEdge(phi, b, delta, upper, fromBackEdge, origdelta, reason, inp, edge)
  )
}

/**
 * Holds if `e` has an upper (for `upper = true`) or lower
 * (for `upper = false`) bound of `b`.
 */
private predicate baseBound(SemExpr e, int b, boolean upper) {
  Specific::hasConstantBound(e, b, upper)
  or
  upper = false and
  b = 0 and
  semPositive(e.(SemBitAndExpr).getAnOperand()) and
  // REVIEW: We let the language opt out here to preserve original results.
  not Specific::ignoreZeroLowerBound(e)
}

/**
 * Holds if the value being cast has an upper (for `upper = true`) or lower
 * (for `upper = false`) bound within the bounds of the resulting type.
 * For `upper = true` this means that the cast will not overflow and for
 * `upper = false` this means that the cast will not underflow.
 */
private predicate safeNarrowingCast(NarrowingCastExpr cast, boolean upper) {
  exists(int bound | bounded(cast.getOperand(), any(SemZeroBound zb), bound, upper, _, _, _) |
    upper = true and bound <= cast.getUpperBound()
    or
    upper = false and bound >= cast.getLowerBound()
  )
}

pragma[noinline]
private predicate boundedCastExpr(
  NarrowingCastExpr cast, SemBound b, int delta, boolean upper, boolean fromBackEdge, int origdelta,
  SemReason reason
) {
  bounded(cast.getOperand(), b, delta, upper, fromBackEdge, origdelta, reason)
}

/**
 * Holds if `b + delta` is a valid bound for `e`.
 * - `upper = true`  : `e <= b + delta`
 * - `upper = false` : `e >= b + delta`
 */
private predicate bounded(
  SemExpr e, SemBound b, int delta, boolean upper, boolean fromBackEdge, int origdelta,
  SemReason reason
) {
  not Specific::ignoreExprBound(e) and
  (
    e = b.getExpr(delta) and
    (upper = true or upper = false) and
    fromBackEdge = false and
    origdelta = delta and
    reason = TSemNoReason()
    or
    baseBound(e, delta, upper) and
    b instanceof SemZeroBound and
    fromBackEdge = false and
    origdelta = delta and
    reason = TSemNoReason()
    or
    exists(SemSsaVariable v, SemSsaReadPositionBlock bb |
      boundedSsa(v, bb, b, delta, upper, fromBackEdge, origdelta, reason) and
      e = v.getAUse() and
      bb.getBlock() = e.getBasicBlock()
    )
    or
    exists(SemExpr mid, int d1, int d2 |
      boundFlowStep(e, mid, d1, upper) and
      // Constants have easy, base-case bounds, so let's not infer any recursive bounds.
      not e instanceof SemConstantIntegerExpr and
      bounded(mid, b, d2, upper, fromBackEdge, origdelta, reason) and
      // upper = true:  e <= mid + d1 <= b + d1 + d2 = b + delta
      // upper = false: e >= mid + d1 >= b + d1 + d2 = b + delta
      delta = d1 + d2
    )
    or
    exists(SemSsaPhiNode phi |
      boundedPhi(phi, b, delta, upper, fromBackEdge, origdelta, reason) and
      e = phi.getAUse()
    )
    or
    exists(SemExpr mid, int factor, int d |
      boundFlowStepMul(e, mid, factor) and
      not e instanceof SemConstantIntegerExpr and
      bounded(mid, b, d, upper, fromBackEdge, origdelta, reason) and
      b instanceof SemZeroBound and
      delta = d * factor
    )
    or
    exists(SemExpr mid, int factor, int d |
      boundFlowStepDiv(e, mid, factor) and
      not e instanceof SemConstantIntegerExpr and
      bounded(mid, b, d, upper, fromBackEdge, origdelta, reason) and
      b instanceof SemZeroBound and
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
      SemConditionalExpr cond, int d1, int d2, boolean fbe1, boolean fbe2, int od1, int od2,
      SemReason r1, SemReason r2
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
  )
}

private predicate boundedConditionalExpr(
  SemConditionalExpr cond, SemBound b, boolean upper, boolean branch, int delta,
  boolean fromBackEdge, int origdelta, SemReason reason
) {
  bounded(cond.getBranchExpr(branch), b, delta, upper, fromBackEdge, origdelta, reason)
}
