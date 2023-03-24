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

private import RangeUtils as Utils
private import SignAnalysisCommon
private import experimental.semmle.code.cpp.semantic.analysis.ModulusAnalysis
import experimental.semmle.code.cpp.semantic.SemanticExpr
import experimental.semmle.code.cpp.semantic.SemanticSSA
import experimental.semmle.code.cpp.semantic.SemanticGuard
import experimental.semmle.code.cpp.semantic.SemanticCFG
import experimental.semmle.code.cpp.semantic.SemanticType
import experimental.semmle.code.cpp.semantic.SemanticOpcode
private import ConstantAnalysis
import experimental.semmle.code.cpp.semantic.SemanticLocation

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

signature module DeltaSig {
  bindingset[this]
  class Delta;

  bindingset[d]
  bindingset[result]
  float toFloat(Delta d);

  bindingset[d]
  bindingset[result]
  int toInt(Delta d);

  bindingset[n]
  bindingset[result]
  Delta fromInt(int n);

  bindingset[f]
  Delta fromFloat(float f);
}

signature module LangSig<DeltaSig D> {
  /**
   * Holds if the specified expression should be excluded from the result of `ssaRead()`.
   *
   * This predicate is to keep the results identical to the original Java implementation. It should be
   * removed once we have the new implementation matching the old results exactly.
   */
  predicate ignoreSsaReadCopy(SemExpr e);

  /**
   * Holds if `e >= bound` (if `upper = false`) or `e <= bound` (if `upper = true`).
   */
  predicate hasConstantBound(SemExpr e, D::Delta bound, boolean upper);

  /**
   * Holds if `e >= bound + delta` (if `upper = false`) or `e <= bound + delta` (if `upper = true`).
   */
  predicate hasBound(SemExpr e, SemExpr bound, D::Delta delta, boolean upper);

  /**
   * Ignore the bound on this expression.
   *
   * This predicate is to keep the results identical to the original Java implementation. It should be
   * removed once we have the new implementation matching the old results exactly.
   */
  predicate ignoreExprBound(SemExpr e);

  /**
   * Ignore any inferred zero lower bound on this expression.
   *
   * This predicate is to keep the results identical to the original Java implementation. It should be
   * removed once we have the new implementation matching the old results exactly.
   */
  predicate ignoreZeroLowerBound(SemExpr e);

  /**
   * Holds if the specified expression should be excluded from the result of `ssaRead()`.
   *
   * This predicate is to keep the results identical to the original Java implementation. It should be
   * removed once we have the new implementation matching the old results exactly.
   */
  predicate ignoreSsaReadArithmeticExpr(SemExpr e);

  /**
   * Holds if the specified variable should be excluded from the result of `ssaRead()`.
   *
   * This predicate is to keep the results identical to the original Java implementation. It should be
   * removed once we have the new implementation matching the old results exactly.
   */
  predicate ignoreSsaReadAssignment(SemSsaVariable v);

  /**
   * Adds additional results to `ssaRead()` that are specific to Java.
   *
   * This predicate handles propagation of offsets for post-increment and post-decrement expressions
   * in exactly the same way as the old Java implementation. Once the new implementation matches the
   * old one, we should remove this predicate and propagate deltas for all similar patterns, whether
   * or not they come from a post-increment/decrement expression.
   */
  SemExpr specificSsaRead(SemSsaVariable v, D::Delta delta);

  /**
   * Holds if the value of `dest` is known to be `src + delta`.
   */
  predicate additionalValueFlowStep(SemExpr dest, SemExpr src, D::Delta delta);

  /**
   * Gets the type that range analysis should use to track the result of the specified expression,
   * if a type other than the original type of the expression is to be used.
   *
   * This predicate is commonly used in languages that support immutable "boxed" types that are
   * actually references but whose values can be tracked as the type contained in the box.
   */
  SemType getAlternateType(SemExpr e);

  /**
   * Gets the type that range analysis should use to track the result of the specified source
   * variable, if a type other than the original type of the expression is to be used.
   *
   * This predicate is commonly used in languages that support immutable "boxed" types that are
   * actually references but whose values can be tracked as the type contained in the box.
   */
  SemType getAlternateTypeForSsaVariable(SemSsaVariable var);
}

signature module UtilSig<DeltaSig DeltaParam> {
  SemExpr semSsaRead(SemSsaVariable v, DeltaParam::Delta delta);

  SemGuard semEqFlowCond(
    SemSsaVariable v, SemExpr e, DeltaParam::Delta delta, boolean isEq, boolean testIsTrue
  );

  predicate semSsaUpdateStep(SemSsaExplicitUpdate v, SemExpr e, DeltaParam::Delta delta);

  predicate semValueFlowStep(SemExpr e2, SemExpr e1, DeltaParam::Delta delta);

  /**
   * Gets the type used to track the specified source variable's range information.
   *
   * Usually, this just `e.getType()`, but the language can override this to track immutable boxed
   * primitive types as the underlying primitive type.
   */
  SemType getTrackedTypeForSsaVariable(SemSsaVariable var);

  /**
   * Gets the type used to track the specified expression's range information.
   *
   * Usually, this just `e.getSemType()`, but the language can override this to track immutable boxed
   * primitive types as the underlying primitive type.
   */
  SemType getTrackedType(SemExpr e);
}

signature module BoundSig<DeltaSig D> {
  class SemBound {
    string toString();

    SemLocation getLocation();

    SemExpr getExpr(D::Delta delta);
  }

  class SemZeroBound extends SemBound;

  class SemSsaBound extends SemBound {
    SemSsaVariable getAVariable();
  }
}

module RangeStage<DeltaSig D, BoundSig<D> Bounds, LangSig<D> LangParam, UtilSig<D> UtilParam> {
  private import Bounds
  private import LangParam
  private import UtilParam
  private import D

  /**
   * An expression that does conversion, boxing, or unboxing
   */
  private class ConvertOrBoxExpr instanceof SemUnaryExpr {
    ConvertOrBoxExpr() {
      this instanceof SemConvertExpr
      or
      this instanceof SemBoxExpr
      or
      this instanceof SemUnboxExpr
    }

    string toString() { result = super.toString() }

    SemExpr getOperand() { result = super.getOperand() }
  }

  /**
   * A cast that can be ignored for the purpose of range analysis.
   */
  private class SafeCastExpr extends ConvertOrBoxExpr {
    SafeCastExpr() {
      conversionCannotOverflow(getTrackedType(pragma[only_bind_into](getOperand())),
        pragma[only_bind_out](getTrackedType(this)))
    }
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

  private module SignAnalysisInstantiated = SignAnalysis<D, UtilParam>; // TODO: will this cause reevaluation if it's instantiated with the same DeltaSig and UtilParam multiple times?

  private import SignAnalysisInstantiated

  private module ModulusAnalysisInstantiated = ModulusAnalysis<D, Bounds, UtilParam>; // TODO: will this cause reevaluation if it's instantiated with the same DeltaSig and UtilParam multiple times?

  private import ModulusAnalysisInstantiated

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
      predicate semBounded(SemExpr e, SemBound b, D::Delta delta, boolean upper, SemReason reason) {
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
  private predicate bestBound(SemExpr e, SemBound b, D::Delta delta, boolean upper) {
    delta = min(D::Delta d | bounded(e, b, d, upper, _, _, _) | d order by D::toFloat(d)) and
    upper = true
    or
    delta = max(D::Delta d | bounded(e, b, d, upper, _, _, _) | d order by D::toFloat(d)) and
    upper = false
  }

  /**
   * Holds if `comp` corresponds to:
   * - `upper = true`  : `v <= e + delta` or `v < e + delta`
   * - `upper = false` : `v >= e + delta` or `v > e + delta`
   */
  private predicate boundCondition(
    SemRelationalExpr comp, SemSsaVariable v, SemExpr e, D::Delta delta, boolean upper
  ) {
    comp.getLesserOperand() = semSsaRead(v, delta) and
    e = comp.getGreaterOperand() and
    upper = true
    or
    comp.getGreaterOperand() = semSsaRead(v, delta) and
    e = comp.getLesserOperand() and
    upper = false
    or
    exists(SemSubExpr sub, SemConstantIntegerExpr c, D::Delta d |
      // (v - d) - e < c
      comp.getLesserOperand() = sub and
      comp.getGreaterOperand() = c and
      sub.getLeftOperand() = semSsaRead(v, d) and
      sub.getRightOperand() = e and
      upper = true and
      delta = D::fromFloat(D::toFloat(d) + c.getIntValue())
      or
      // (v - d) - e > c
      comp.getGreaterOperand() = sub and
      comp.getLesserOperand() = c and
      sub.getLeftOperand() = semSsaRead(v, d) and
      sub.getRightOperand() = e and
      upper = false and
      delta = D::fromFloat(D::toFloat(d) + c.getIntValue())
      or
      // e - (v - d) < c
      comp.getLesserOperand() = sub and
      comp.getGreaterOperand() = c and
      sub.getLeftOperand() = e and
      sub.getRightOperand() = semSsaRead(v, d) and
      upper = false and
      delta = D::fromFloat(D::toFloat(d) - c.getIntValue())
      or
      // e - (v - d) > c
      comp.getGreaterOperand() = sub and
      comp.getLesserOperand() = c and
      sub.getLeftOperand() = e and
      sub.getRightOperand() = semSsaRead(v, d) and
      upper = true and
      delta = D::fromFloat(D::toFloat(d) - c.getIntValue())
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
    SemSsaVariable v, SemExpr e, D::Delta delta, boolean upper, boolean testIsTrue
  ) {
    exists(
      SemRelationalExpr comp, D::Delta d1, float d2, float d3, int strengthen, boolean compIsUpper,
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
        if
          getTrackedTypeForSsaVariable(v) instanceof SemIntegerType or
          getTrackedTypeForSsaVariable(v) instanceof SemAddressType
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
      delta = D::fromFloat(D::toFloat(d1) + d2 + d3)
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
    exists(
      SemSsaVariable v2, SemGuard guardEq, boolean eqIsTrue, D::Delta d1, D::Delta d2,
      D::Delta oldDelta
    |
      guardEq = semEqFlowCond(v, semSsaRead(v2, d1), d2, true, eqIsTrue) and
      result = boundFlowCond(v2, e, oldDelta, upper, testIsTrue) and
      // guardEq needs to control guard
      guardEq.directlyControls(result.getBasicBlock(), eqIsTrue) and
      delta = D::fromFloat(D::toFloat(oldDelta) - D::toFloat(d1) + D::toFloat(d2))
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
    SemSsaVariable v, SemSsaReadPosition pos, SemExpr e, D::Delta delta, boolean upper,
    SemReason reason
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
    SemSsaVariable v, SemSsaReadPosition pos, SemExpr e, D::Delta delta, SemReason reason
  ) {
    getTrackedTypeForSsaVariable(v) instanceof SemIntegerType and
    exists(SemGuard guard, boolean testIsTrue |
      pos.hasReadOfVar(v) and
      guard = semEqFlowCond(v, e, delta, false, testIsTrue) and
      semGuardDirectlyControlsSsaRead(guard, pos, testIsTrue) and
      reason = TSemCondReason(guard)
    )
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
  private predicate boundFlowStep(SemExpr e2, SemExpr e1, D::Delta delta, boolean upper) {
    semValueFlowStep(e2, e1, delta) and
    (upper = true or upper = false)
    or
    e2.(SafeCastExpr).getOperand() = e1 and
    delta = D::fromInt(0) and
    (upper = true or upper = false)
    or
    exists(SemExpr x | e2.(SemAddExpr).hasOperands(e1, x) |
      // `x instanceof ConstantIntegerExpr` is covered by valueFlowStep
      not x instanceof SemConstantIntegerExpr and
      not e1 instanceof SemConstantIntegerExpr and
      if strictlyPositiveIntegralExpr(x)
      then upper = false and delta = D::fromInt(1)
      else
        if semPositive(x)
        then upper = false and delta = D::fromInt(0)
        else
          if strictlyNegativeIntegralExpr(x)
          then upper = true and delta = D::fromInt(-1)
          else
            if semNegative(x)
            then upper = true and delta = D::fromInt(0)
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
      then upper = true and delta = D::fromInt(-1)
      else
        if semPositive(x)
        then upper = true and delta = D::fromInt(0)
        else
          if strictlyNegativeIntegralExpr(x)
          then upper = false and delta = D::fromInt(1)
          else
            if semNegative(x)
            then upper = false and delta = D::fromInt(0)
            else none()
    )
    or
    e2.(SemRemExpr).getRightOperand() = e1 and
    semPositive(e1) and
    delta = D::fromInt(-1) and
    upper = true
    or
    e2.(SemRemExpr).getLeftOperand() = e1 and
    semPositive(e1) and
    delta = D::fromInt(0) and
    upper = true
    or
    e2.(SemBitAndExpr).getAnOperand() = e1 and
    semPositive(e1) and
    delta = D::fromInt(0) and
    upper = true
    or
    e2.(SemBitOrExpr).getAnOperand() = e1 and
    semPositive(e2) and
    delta = D::fromInt(0) and
    upper = false
    or
    hasBound(e2, e1, delta, upper)
  }

  /** Holds if `e2 = e1 * factor` and `factor > 0`. */
  private predicate boundFlowStepMul(SemExpr e2, SemExpr e1, D::Delta factor) {
    exists(SemConstantIntegerExpr c, int k | k = c.getIntValue() and k > 0 |
      e2.(SemMulExpr).hasOperands(e1, c) and factor = D::fromInt(k)
      or
      exists(SemShiftLeftExpr e |
        e = e2 and
        e.getLeftOperand() = e1 and
        e.getRightOperand() = c and
        factor = D::fromInt(2.pow(k))
      )
    )
  }

  /**
   * Holds if `e2 = e1 / factor` and `factor > 0`.
   *
   * This conflates division, right shift, and unsigned right shift and is
   * therefore only valid for non-negative numbers.
   */
  private predicate boundFlowStepDiv(SemExpr e2, SemExpr e1, D::Delta factor) {
    exists(SemConstantIntegerExpr c, D::Delta k |
      k = D::fromInt(c.getIntValue()) and D::toFloat(k) > 0
    |
      exists(SemDivExpr e |
        e = e2 and e.getLeftOperand() = e1 and e.getRightOperand() = c and factor = k
      )
      or
      exists(SemShiftRightExpr e |
        e = e2 and
        e.getLeftOperand() = e1 and
        e.getRightOperand() = c and
        factor = D::fromInt(2.pow(D::toInt(k)))
      )
      or
      exists(SemShiftRightUnsignedExpr e |
        e = e2 and
        e.getLeftOperand() = e1 and
        e.getRightOperand() = c and
        factor = D::fromInt(2.pow(D::toInt(k)))
      )
    )
  }

  /**
   * Holds if `b + delta` is a valid bound for `v` at `pos`.
   * - `upper = true`  : `v <= b + delta`
   * - `upper = false` : `v >= b + delta`
   */
  private predicate boundedSsa(
    SemSsaVariable v, SemSsaReadPosition pos, SemBound b, D::Delta delta, boolean upper,
    boolean fromBackEdge, D::Delta origdelta, SemReason reason
  ) {
    exists(SemExpr mid, D::Delta d1, D::Delta d2, SemReason r1, SemReason r2 |
      boundFlowStepSsa(v, pos, mid, d1, upper, r1) and
      bounded(mid, b, d2, upper, fromBackEdge, origdelta, r2) and
      // upper = true:  v <= mid + d1 <= b + d1 + d2 = b + delta
      // upper = false: v >= mid + d1 >= b + d1 + d2 = b + delta
      delta = D::fromFloat(D::toFloat(d1) + D::toFloat(d2)) and
      (if r1 instanceof SemNoReason then reason = r2 else reason = r1)
    )
    or
    exists(D::Delta d, SemReason r1, SemReason r2 |
      boundedSsa(v, pos, b, d, upper, fromBackEdge, origdelta, r2) or
      boundedPhi(v, b, d, upper, fromBackEdge, origdelta, r2)
    |
      unequalIntegralSsa(v, pos, b, d, r1) and
      (
        upper = true and delta = D::fromFloat(D::toFloat(d) - 1)
        or
        upper = false and delta = D::fromFloat(D::toFloat(d) + 1)
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
    SemSsaVariable v, SemSsaReadPosition pos, SemBound b, D::Delta delta, SemReason reason
  ) {
    exists(SemExpr e, D::Delta d1, D::Delta d2 |
      unequalFlowStepIntegralSsa(v, pos, e, d1, reason) and
      boundedUpper(e, b, d1) and
      boundedLower(e, b, d2) and
      delta = D::fromFloat(D::toFloat(d1) + D::toFloat(d2))
    )
  }

  /**
   * Holds if `b + delta` is an upper bound for `e`.
   *
   * This predicate only exists to prevent a bad standard order in `unequalIntegralSsa`.
   */
  pragma[nomagic]
  private predicate boundedUpper(SemExpr e, SemBound b, D::Delta delta) {
    bounded(e, b, delta, true, _, _, _)
  }

  /**
   * Holds if `b + delta` is a lower bound for `e`.
   *
   * This predicate only exists to prevent a bad standard order in `unequalIntegralSsa`.
   */
  pragma[nomagic]
  private predicate boundedLower(SemExpr e, SemBound b, D::Delta delta) {
    bounded(e, b, delta, false, _, _, _)
  }

  /** Weakens a delta to lie in the range `[-1..1]`. */
  bindingset[delta, upper]
  private D::Delta weakenDelta(boolean upper, D::Delta delta) {
    delta = D::fromFloat([-1 .. 1]) and result = delta
    or
    upper = true and result = D::fromFloat(-1) and D::toFloat(delta) < -1
    or
    upper = false and result = D::fromFloat(1) and D::toFloat(delta) > 1
  }

  /**
   * Holds if `b + delta` is a valid bound for `inp` when used as an input to
   * `phi` along `edge`.
   * - `upper = true`  : `inp <= b + delta`
   * - `upper = false` : `inp >= b + delta`
   */
  private predicate boundedPhiInp(
    SemSsaPhiNode phi, SemSsaVariable inp, SemSsaReadPositionPhiInputEdge edge, SemBound b,
    D::Delta delta, boolean upper, boolean fromBackEdge, D::Delta origdelta, SemReason reason
  ) {
    edge.phiInput(phi, inp) and
    exists(D::Delta d, boolean fromBackEdge0 |
      boundedSsa(inp, edge, b, d, upper, fromBackEdge0, origdelta, reason)
      or
      boundedPhi(inp, b, d, upper, fromBackEdge0, origdelta, reason)
      or
      b.(SemSsaBound).getAVariable() = inp and
      d = D::fromFloat(0) and
      (upper = true or upper = false) and
      fromBackEdge0 = false and
      origdelta = D::fromFloat(0) and
      reason = TSemNoReason()
    |
      if semBackEdge(phi, inp, edge)
      then
        fromBackEdge = true and
        (
          fromBackEdge0 = true and
          delta =
            D::fromFloat(D::toFloat(weakenDelta(upper,
                    D::fromFloat(D::toFloat(d) - D::toFloat(origdelta)))) + D::toFloat(origdelta))
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
    SemSsaReadPositionPhiInputEdge edge, D::Delta delta
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
    exists(D::Delta d, SemSsaBound phibound |
      phibound.getAVariable() = phi and
      boundedPhiInp(phi, inp, edge, phibound, d, upper, _, _, _) and
      (
        upper = true and D::toFloat(d) <= 0
        or
        upper = false and D::toFloat(d) >= 0
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
    SemSsaPhiNode phi, boolean upper, SemBound b, D::Delta delta, boolean fromBackEdge,
    D::Delta origdelta, SemReason reason
  ) {
    boundedPhiInp(phi, _, _, b, delta, upper, fromBackEdge, origdelta, reason)
  }

  /**
   * Holds if the candidate bound `b + delta` for `phi` is valid for the phi input
   * `inp` along `edge`.
   */
  private predicate boundedPhiCandValidForEdge(
    SemSsaPhiNode phi, SemBound b, D::Delta delta, boolean upper, boolean fromBackEdge,
    D::Delta origdelta, SemReason reason, SemSsaVariable inp, SemSsaReadPositionPhiInputEdge edge
  ) {
    boundedPhiCand(phi, upper, b, delta, fromBackEdge, origdelta, reason) and
    (
      exists(D::Delta d | boundedPhiInp1(phi, b, upper, inp, edge, d) |
        upper = true and D::toFloat(d) <= D::toFloat(delta)
      )
      or
      exists(D::Delta d | boundedPhiInp1(phi, b, upper, inp, edge, d) |
        upper = false and D::toFloat(d) >= D::toFloat(delta)
      )
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
    SemSsaPhiNode phi, SemBound b, D::Delta delta, boolean upper, boolean fromBackEdge,
    D::Delta origdelta, SemReason reason
  ) {
    forex(SemSsaVariable inp, SemSsaReadPositionPhiInputEdge edge | edge.phiInput(phi, inp) |
      boundedPhiCandValidForEdge(phi, b, delta, upper, fromBackEdge, origdelta, reason, inp, edge)
    )
  }

  /**
   * Holds if `e` has an upper (for `upper = true`) or lower
   * (for `upper = false`) bound of `b`.
   */
  private predicate baseBound(SemExpr e, D::Delta b, boolean upper) {
    hasConstantBound(e, b, upper)
    or
    upper = false and
    b = D::fromInt(0) and
    semPositive(e.(SemBitAndExpr).getAnOperand()) and
    // REVIEW: We let the language opt out here to preserve original results.
    not ignoreZeroLowerBound(e)
  }

  /**
   * Holds if the value being cast has an upper (for `upper = true`) or lower
   * (for `upper = false`) bound within the bounds of the resulting type.
   * For `upper = true` this means that the cast will not overflow and for
   * `upper = false` this means that the cast will not underflow.
   */
  private predicate safeNarrowingCast(NarrowingCastExpr cast, boolean upper) {
    exists(D::Delta bound |
      bounded(cast.getOperand(), any(SemZeroBound zb), bound, upper, _, _, _)
    |
      upper = true and D::toFloat(bound) <= cast.getUpperBound()
      or
      upper = false and D::toFloat(bound) >= cast.getLowerBound()
    )
  }

  pragma[noinline]
  private predicate boundedCastExpr(
    NarrowingCastExpr cast, SemBound b, D::Delta delta, boolean upper, boolean fromBackEdge,
    D::Delta origdelta, SemReason reason
  ) {
    bounded(cast.getOperand(), b, delta, upper, fromBackEdge, origdelta, reason)
  }

  /**
   * Computes a normal form of `x` where -0.0 has changed to +0.0. This can be
   * needed on the lesser side of a floating-point comparison or on both sides of
   * a floating point equality because QL does not follow IEEE in floating-point
   * comparisons but instead defines -0.0 to be less than and distinct from 0.0.
   */
  bindingset[x]
  private float normalizeFloatUp(float x) { result = x + 0.0 }

  /**
   * Holds if `b + delta` is a valid bound for `e`.
   * - `upper = true`  : `e <= b + delta`
   * - `upper = false` : `e >= b + delta`
   */
  private predicate bounded(
    SemExpr e, SemBound b, D::Delta delta, boolean upper, boolean fromBackEdge, D::Delta origdelta,
    SemReason reason
  ) {
    not ignoreExprBound(e) and
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
      exists(SemExpr mid, D::Delta d1, D::Delta d2 |
        boundFlowStep(e, mid, d1, upper) and
        // Constants have easy, base-case bounds, so let's not infer any recursive bounds.
        not e instanceof SemConstantIntegerExpr and
        bounded(mid, b, d2, upper, fromBackEdge, origdelta, reason) and
        // upper = true:  e <= mid + d1 <= b + d1 + d2 = b + delta
        // upper = false: e >= mid + d1 >= b + d1 + d2 = b + delta
        delta = D::fromFloat(D::toFloat(d1) + D::toFloat(d2))
      )
      or
      exists(SemSsaPhiNode phi |
        boundedPhi(phi, b, delta, upper, fromBackEdge, origdelta, reason) and
        e = phi.getAUse()
      )
      or
      exists(SemExpr mid, D::Delta factor, D::Delta d |
        boundFlowStepMul(e, mid, factor) and
        not e instanceof SemConstantIntegerExpr and
        bounded(mid, b, d, upper, fromBackEdge, origdelta, reason) and
        b instanceof SemZeroBound and
        delta = D::fromFloat(D::toFloat(d) * D::toFloat(factor))
      )
      or
      exists(SemExpr mid, D::Delta factor, D::Delta d |
        boundFlowStepDiv(e, mid, factor) and
        not e instanceof SemConstantIntegerExpr and
        bounded(mid, b, d, upper, fromBackEdge, origdelta, reason) and
        b instanceof SemZeroBound and
        D::toFloat(d) >= 0 and
        delta = D::fromFloat(D::toFloat(d) / D::toFloat(factor))
      )
      or
      exists(NarrowingCastExpr cast |
        cast = e and
        safeNarrowingCast(cast, upper.booleanNot()) and
        boundedCastExpr(cast, b, delta, upper, fromBackEdge, origdelta, reason)
      )
      or
      exists(
        SemConditionalExpr cond, D::Delta d1, D::Delta d2, boolean fbe1, boolean fbe2, D::Delta od1,
        D::Delta od2, SemReason r1, SemReason r2
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
        upper = true and delta = D::fromFloat(D::toFloat(d1).maximum(D::toFloat(d2)))
        or
        upper = false and delta = D::fromFloat(D::toFloat(d1).minimum(D::toFloat(d2)))
      )
      or
      exists(SemExpr mid, D::Delta d, float f |
        e.(SemNegateExpr).getOperand() = mid and
        b instanceof SemZeroBound and
        bounded(mid, b, d, upper.booleanNot(), fromBackEdge, origdelta, reason) and
        f = normalizeFloatUp(-D::toFloat(d)) and
        delta = D::fromFloat(f) and
        if semPositive(e) then f >= 0 else any()
      )
    )
  }

  private predicate boundedConditionalExpr(
    SemConditionalExpr cond, SemBound b, boolean upper, boolean branch, D::Delta delta,
    boolean fromBackEdge, D::Delta origdelta, SemReason reason
  ) {
    bounded(cond.getBranchExpr(branch), b, delta, upper, fromBackEdge, origdelta, reason)
  }
}
