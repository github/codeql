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

private import codeql.util.Location

signature module Semantic {
  class Expr {
    string toString();

    BasicBlock getBasicBlock();
  }

  class ConstantIntegerExpr extends Expr {
    int getIntValue();
  }

  class BinaryExpr extends Expr {
    Expr getLeftOperand();

    Expr getRightOperand();

    Expr getAnOperand();

    predicate hasOperands(Expr e1, Expr e2);
  }

  class AddExpr extends BinaryExpr;

  class SubExpr extends BinaryExpr;

  class MulExpr extends BinaryExpr;

  class DivExpr extends BinaryExpr;

  class RemExpr extends BinaryExpr;

  class BitAndExpr extends BinaryExpr;

  class BitOrExpr extends BinaryExpr;

  class ShiftLeftExpr extends BinaryExpr;

  class ShiftRightExpr extends BinaryExpr;

  class ShiftRightUnsignedExpr extends BinaryExpr;

  default predicate isAssignOp(BinaryExpr bin) { none() }

  class RelationalExpr extends Expr {
    Expr getLesserOperand();

    Expr getGreaterOperand();

    predicate isStrict();
  }

  class UnaryExpr extends Expr {
    Expr getOperand();
  }

  class ConvertExpr extends UnaryExpr;

  class BoxExpr extends UnaryExpr;

  class UnboxExpr extends UnaryExpr;

  class NegateExpr extends UnaryExpr;

  class PreIncExpr extends UnaryExpr;

  class PreDecExpr extends UnaryExpr;

  class PostIncExpr extends UnaryExpr;

  class PostDecExpr extends UnaryExpr;

  class CopyValueExpr extends UnaryExpr;

  class ConditionalExpr extends Expr {
    Expr getBranchExpr(boolean branch);
  }

  class BasicBlock;

  class Guard {
    string toString();

    BasicBlock getBasicBlock();

    Expr asExpr();

    predicate directlyControls(BasicBlock controlled, boolean branch);

    predicate isEquality(Expr e1, Expr e2, boolean polarity);
  }

  predicate implies_v2(Guard g1, boolean b1, Guard g2, boolean b2);

  predicate guardDirectlyControlsSsaRead(Guard guard, SsaReadPosition controlled, boolean testIsTrue);

  predicate guardControlsSsaRead(Guard guard, SsaReadPosition controlled, boolean testIsTrue);

  class Type;

  class IntegerType extends Type {
    predicate isSigned();

    int getByteSize();
  }

  class FloatingPointType extends Type;

  class AddressType extends Type;

  class SsaVariable {
    Expr getAUse();
  }

  class SsaPhiNode extends SsaVariable;

  class SsaExplicitUpdate extends SsaVariable {
    Expr getDefiningExpr();
  }

  class SsaReadPosition {
    predicate hasReadOfVar(SsaVariable v);
  }

  class SsaReadPositionPhiInputEdge extends SsaReadPosition {
    predicate phiInput(SsaPhiNode phi, SsaVariable inp);
  }

  class SsaReadPositionBlock extends SsaReadPosition {
    BasicBlock getBlock();
  }

  predicate backEdge(SsaPhiNode phi, SsaVariable inp, SsaReadPositionPhiInputEdge edge);

  predicate conversionCannotOverflow(Type fromType, Type toType);
}

signature module SignAnalysisSig<Semantic Sem> {
  /** Holds if `e` can be positive and cannot be negative. */
  predicate semPositive(Sem::Expr e);

  /** Holds if `e` can be negative and cannot be positive. */
  predicate semNegative(Sem::Expr e);

  /** Holds if `e` is strictly positive. */
  predicate semStrictlyPositive(Sem::Expr e);

  /** Holds if `e` is strictly negative. */
  predicate semStrictlyNegative(Sem::Expr e);

  /**
   * Holds if `e` may have positive values. This does not rule out the
   * possibility for negative values.
   */
  predicate semMayBePositive(Sem::Expr e);

  /**
   * Holds if `e` may have negative values. This does not rule out the
   * possibility for positive values.
   */
  predicate semMayBeNegative(Sem::Expr e);
}

signature module ModulusAnalysisSig<Semantic Sem> {
  class ModBound;

  predicate exprModulus(Sem::Expr e, ModBound b, int val, int mod);
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

signature module LangSig<Semantic Sem, DeltaSig D> {
  /**
   * Holds if `e >= bound` (if `upper = false`) or `e <= bound` (if `upper = true`).
   */
  predicate hasConstantBound(Sem::Expr e, D::Delta bound, boolean upper);

  /**
   * Holds if `e >= bound + delta` (if `upper = false`) or `e <= bound + delta` (if `upper = true`).
   */
  predicate hasBound(Sem::Expr e, Sem::Expr bound, D::Delta delta, boolean upper);

  /**
   * Ignore the bound on this expression.
   *
   * This predicate is to keep the results identical to the original Java implementation. It should be
   * removed once we have the new implementation matching the old results exactly.
   */
  predicate ignoreExprBound(Sem::Expr e);

  /**
   * Holds if the value of `dest` is known to be `src + delta`.
   */
  predicate additionalValueFlowStep(Sem::Expr dest, Sem::Expr src, D::Delta delta);

  /**
   * Gets the type that range analysis should use to track the result of the specified expression,
   * if a type other than the original type of the expression is to be used.
   *
   * This predicate is commonly used in languages that support immutable "boxed" types that are
   * actually references but whose values can be tracked as the type contained in the box.
   */
  Sem::Type getAlternateType(Sem::Expr e);

  /**
   * Gets the type that range analysis should use to track the result of the specified source
   * variable, if a type other than the original type of the expression is to be used.
   *
   * This predicate is commonly used in languages that support immutable "boxed" types that are
   * actually references but whose values can be tracked as the type contained in the box.
   */
  Sem::Type getAlternateTypeForSsaVariable(Sem::SsaVariable var);

  default predicate javaCompatibility() { none() }
}

signature module UtilSig<Semantic Sem, DeltaSig DeltaParam> {
  Sem::Guard semEqFlowCond(
    Sem::SsaVariable v, Sem::Expr e, DeltaParam::Delta delta, boolean isEq, boolean testIsTrue
  );

  predicate semSsaUpdateStep(Sem::SsaExplicitUpdate v, Sem::Expr e, DeltaParam::Delta delta);

  predicate semValueFlowStep(Sem::Expr e2, Sem::Expr e1, DeltaParam::Delta delta);

  /**
   * Gets the type used to track the specified source variable's range information.
   *
   * Usually, this just `e.getType()`, but the language can override this to track immutable boxed
   * primitive types as the underlying primitive type.
   */
  Sem::Type getTrackedTypeForSsaVariable(Sem::SsaVariable var);

  /**
   * Gets the type used to track the specified expression's range information.
   *
   * Usually, this just `e.getSemType()`, but the language can override this to track immutable boxed
   * primitive types as the underlying primitive type.
   */
  Sem::Type getTrackedType(Sem::Expr e);

  /**
   * Holds if `inp` is an input to `phi` along `edge` and this input has index `r`
   * in an arbitrary 1-based numbering of the input edges to `phi`.
   */
  predicate rankedPhiInput(
    Sem::SsaPhiNode phi, Sem::SsaVariable inp, Sem::SsaReadPositionPhiInputEdge edge, int r
  );

  /**
   * Holds if `rix` is the number of input edges to `phi`.
   */
  predicate maxPhiInputRank(Sem::SsaPhiNode phi, int rix);
}

signature module BoundSig<LocationSig Location, Semantic Sem, DeltaSig D> {
  class SemBound {
    string toString();

    Location getLocation();

    Sem::Expr getExpr(D::Delta delta);
  }

  class SemZeroBound extends SemBound;

  class SemSsaBound extends SemBound {
    Sem::SsaVariable getVariable();
  }
}

signature module OverflowSig<Semantic Sem, DeltaSig D> {
  predicate semExprDoesNotOverflow(boolean positively, Sem::Expr expr);
}

module RangeStage<
  LocationSig Location, Semantic Sem, DeltaSig D, BoundSig<Location, Sem, D> Bounds,
  OverflowSig<Sem, D> OverflowParam, LangSig<Sem, D> LangParam, SignAnalysisSig<Sem> SignAnalysis,
  ModulusAnalysisSig<Sem> ModulusAnalysisParam, UtilSig<Sem, D> UtilParam>
{
  private import Bounds
  private import LangParam
  private import UtilParam
  private import D
  private import OverflowParam
  private import SignAnalysis
  private import ModulusAnalysisParam
  private import internal.RangeUtils::MakeUtils<Sem, D>

  /**
   * An expression that does conversion, boxing, or unboxing
   */
  private class ConvertOrBoxExpr instanceof Sem::UnaryExpr {
    ConvertOrBoxExpr() {
      this instanceof Sem::ConvertExpr
      or
      this instanceof Sem::BoxExpr
      or
      this instanceof Sem::UnboxExpr
    }

    string toString() { result = super.toString() }

    Sem::Expr getOperand() { result = super.getOperand() }
  }

  /**
   * Holds if `typ` is a small integral type with the given lower and upper bounds.
   */
  private predicate typeBound(Sem::IntegerType typ, float lowerbound, float upperbound) {
    exists(int bitSize | bitSize = typ.getByteSize() * 8 |
      if typ.isSigned()
      then (
        upperbound = 2.pow(bitSize - 1) - 1 and
        lowerbound = -upperbound - 1
      ) else (
        lowerbound = 0 and
        upperbound = 2.pow(bitSize) - 1
      )
    )
  }

  /**
   * A cast that can be ignored for the purpose of range analysis.
   */
  private class SafeCastExpr extends ConvertOrBoxExpr {
    SafeCastExpr() {
      Sem::conversionCannotOverflow(getTrackedType(pragma[only_bind_into](this.getOperand())),
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
    float getLowerBound() { typeBound(getTrackedType(this), result, _) }

    /** Gets the upper bound of the resulting type. */
    float getUpperBound() { typeBound(getTrackedType(this), _, result) }
  }

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
      predicate semBounded(Sem::Expr e, SemBound b, D::Delta delta, boolean upper, SemReason reason) {
        bounded(e, b, delta, upper, _, _, reason) and
        bestBound(e, b, delta, upper)
      }
    }

    /**
     * Holds if `guard = boundFlowCond(_, _, _, _, _) or guard = eqFlowCond(_, _, _, _, _)`.
     */
    cached
    predicate possibleReason(Sem::Guard guard) {
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
  private predicate bestBound(Sem::Expr e, SemBound b, D::Delta delta, boolean upper) {
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
    Sem::RelationalExpr comp, Sem::SsaVariable v, Sem::Expr e, D::Delta delta, boolean upper
  ) {
    comp.getLesserOperand() = ssaRead(v, delta) and
    e = comp.getGreaterOperand() and
    upper = true
    or
    comp.getGreaterOperand() = ssaRead(v, delta) and
    e = comp.getLesserOperand() and
    upper = false
    or
    exists(Sem::SubExpr sub, Sem::ConstantIntegerExpr c, D::Delta d |
      // (v - d) - e < c
      comp.getLesserOperand() = sub and
      comp.getGreaterOperand() = c and
      sub.getLeftOperand() = ssaRead(v, d) and
      sub.getRightOperand() = e and
      upper = true and
      delta = D::fromFloat(D::toFloat(d) + c.getIntValue())
      or
      // (v - d) - e > c
      comp.getGreaterOperand() = sub and
      comp.getLesserOperand() = c and
      sub.getLeftOperand() = ssaRead(v, d) and
      sub.getRightOperand() = e and
      upper = false and
      delta = D::fromFloat(D::toFloat(d) + c.getIntValue())
      or
      // e - (v - d) < c
      comp.getLesserOperand() = sub and
      comp.getGreaterOperand() = c and
      sub.getLeftOperand() = e and
      sub.getRightOperand() = ssaRead(v, d) and
      upper = false and
      delta = D::fromFloat(D::toFloat(d) - c.getIntValue())
      or
      // e - (v - d) > c
      comp.getGreaterOperand() = sub and
      comp.getLesserOperand() = c and
      sub.getLeftOperand() = e and
      sub.getRightOperand() = ssaRead(v, d) and
      upper = true and
      delta = D::fromFloat(D::toFloat(d) - c.getIntValue())
    )
  }

  /**
   * Holds if `comp` is a comparison between `x` and `y` for which `y - x` has a
   * fixed value modulo some `mod > 1`, such that the comparison can be
   * strengthened by `strengthen` when evaluating to `testIsTrue`.
   */
  private predicate modulusComparison(Sem::RelationalExpr comp, boolean testIsTrue, int strengthen) {
    exists(
      ModBound b, int v1, int v2, int mod1, int mod2, int mod, boolean resultIsStrict, int d, int k
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
  private Sem::Guard boundFlowCond(
    Sem::SsaVariable v, Sem::Expr e, D::Delta delta, boolean upper, boolean testIsTrue
  ) {
    exists(
      Sem::RelationalExpr comp, D::Delta d1, float d2, float d3, int strengthen,
      boolean compIsUpper, boolean resultIsStrict
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
          getTrackedTypeForSsaVariable(v) instanceof Sem::IntegerType or
          getTrackedTypeForSsaVariable(v) instanceof Sem::AddressType
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
      Sem::implies_v2(result, testIsTrue, boundFlowCond(v, e, delta, upper, testIsTrue0),
        testIsTrue0)
    )
    or
    result = semEqFlowCond(v, e, delta, true, testIsTrue) and
    (upper = true or upper = false)
    or
    // guard that tests whether `v2` is bounded by `e + delta + d1 - d2` and
    // exists a guard `guardEq` such that `v = v2 - d1 + d2`.
    exists(Sem::SsaVariable v2, D::Delta oldDelta, float d |
      // equality needs to control guard
      result.getBasicBlock() = eqSsaCondDirectlyControls(v, v2, d) and
      result = boundFlowCond(v2, e, oldDelta, upper, testIsTrue) and
      delta = D::fromFloat(D::toFloat(oldDelta) + d)
    )
  }

  /**
   * Gets a basic block in which `v1` equals `v2 + delta`.
   */
  pragma[nomagic]
  private Sem::BasicBlock eqSsaCondDirectlyControls(
    Sem::SsaVariable v1, Sem::SsaVariable v2, float delta
  ) {
    exists(Sem::Guard guardEq, D::Delta d1, D::Delta d2, boolean eqIsTrue |
      guardEq = semEqFlowCond(v1, ssaRead(v2, d1), d2, true, eqIsTrue) and
      delta = D::toFloat(d2) - D::toFloat(d1) and
      guardEq.directlyControls(result, eqIsTrue)
    )
  }

  private newtype TSemReason =
    TSemNoReason() or
    TSemCondReason(Sem::Guard guard) { possibleReason(guard) }

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
    Sem::Guard getCond() { this = TSemCondReason(result) }

    override string toString() { result = this.getCond().toString() }
  }

  /**
   * Holds if `e + delta` is a valid bound for `v` at `pos`.
   * - `upper = true`  : `v <= e + delta`
   * - `upper = false` : `v >= e + delta`
   */
  private predicate boundFlowStepSsa(
    Sem::SsaVariable v, Sem::SsaReadPosition pos, Sem::Expr e, D::Delta delta, boolean upper,
    SemReason reason
  ) {
    semSsaUpdateStep(v, e, delta) and
    pos.hasReadOfVar(v) and
    (upper = true or upper = false) and
    reason = TSemNoReason()
    or
    exists(Sem::Guard guard, boolean testIsTrue |
      pos.hasReadOfVar(v) and
      guard = boundFlowCond(v, e, delta, upper, testIsTrue) and
      Sem::guardDirectlyControlsSsaRead(guard, pos, testIsTrue) and
      reason = TSemCondReason(guard)
    )
  }

  /** Holds if `v != e + delta` at `pos` and `v` is of integral type. */
  private predicate unequalFlowStepIntegralSsa(
    Sem::SsaVariable v, Sem::SsaReadPosition pos, Sem::Expr e, D::Delta delta, SemReason reason
  ) {
    getTrackedTypeForSsaVariable(v) instanceof Sem::IntegerType and
    exists(Sem::Guard guard, boolean testIsTrue |
      pos.hasReadOfVar(v) and
      guard = semEqFlowCond(v, e, delta, false, testIsTrue) and
      Sem::guardDirectlyControlsSsaRead(guard, pos, testIsTrue) and
      reason = TSemCondReason(guard)
    )
  }

  /** Holds if `e >= 1` as determined by sign analysis. */
  private predicate strictlyPositiveIntegralExpr(Sem::Expr e) {
    semStrictlyPositive(e) and getTrackedType(e) instanceof Sem::IntegerType
  }

  /** Holds if `e <= -1` as determined by sign analysis. */
  private predicate strictlyNegativeIntegralExpr(Sem::Expr e) {
    semStrictlyNegative(e) and getTrackedType(e) instanceof Sem::IntegerType
  }

  /**
   * Holds if `e1 + delta` is a valid bound for `e2`.
   * - `upper = true`  : `e2 <= e1 + delta`
   * - `upper = false` : `e2 >= e1 + delta`
   */
  private predicate boundFlowStep(Sem::Expr e2, Sem::Expr e1, D::Delta delta, boolean upper) {
    semValueFlowStep(e2, e1, delta) and
    (upper = true or upper = false)
    or
    e2.(SafeCastExpr).getOperand() = e1 and
    delta = D::fromInt(0) and
    (upper = true or upper = false)
    or
    javaCompatibility() and
    exists(Sem::Expr x, Sem::SubExpr sub |
      e2 = sub and
      sub.getLeftOperand() = e1 and
      sub.getRightOperand() = x
    |
      // `x instanceof ConstantIntegerExpr` is covered by valueFlowStep
      not x instanceof Sem::ConstantIntegerExpr and
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
    e2.(Sem::RemExpr).getRightOperand() = e1 and
    semPositive(e1) and
    delta = D::fromInt(-1) and
    upper = true
    or
    e2.(Sem::RemExpr).getLeftOperand() = e1 and
    semPositive(e1) and
    delta = D::fromInt(0) and
    upper = true
    or
    e2.(Sem::BitAndExpr).getAnOperand() = e1 and
    semPositive(e1) and
    delta = D::fromInt(0) and
    upper = true
    or
    e2.(Sem::BitOrExpr).getAnOperand() = e1 and
    semPositive(e2) and
    delta = D::fromInt(0) and
    upper = false
    or
    hasBound(e2, e1, delta, upper)
  }

  /** Holds if `e2 = e1 * factor` and `factor > 0`. */
  private predicate boundFlowStepMul(Sem::Expr e2, Sem::Expr e1, D::Delta factor) {
    exists(Sem::ConstantIntegerExpr c, int k | k = c.getIntValue() and k > 0 |
      e2.(Sem::MulExpr).hasOperands(e1, c) and factor = D::fromInt(k)
      or
      exists(Sem::ShiftLeftExpr e |
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
  private predicate boundFlowStepDiv(Sem::Expr e2, Sem::Expr e1, D::Delta factor) {
    getTrackedType(e2) instanceof Sem::IntegerType and
    exists(Sem::ConstantIntegerExpr c, D::Delta k |
      k = D::fromInt(c.getIntValue()) and D::toFloat(k) > 0
    |
      exists(Sem::DivExpr e |
        e = e2 and e.getLeftOperand() = e1 and e.getRightOperand() = c and factor = k
      )
      or
      exists(Sem::ShiftRightExpr e |
        e = e2 and
        e.getLeftOperand() = e1 and
        e.getRightOperand() = c and
        factor = D::fromInt(2.pow(D::toInt(k)))
      )
      or
      exists(Sem::ShiftRightUnsignedExpr e |
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
    Sem::SsaVariable v, SemBound b, D::Delta delta, Sem::SsaReadPosition pos, boolean upper,
    boolean fromBackEdge, D::Delta origdelta, SemReason reason
  ) {
    exists(Sem::Expr mid, D::Delta d1, D::Delta d2, SemReason r1, SemReason r2 |
      boundFlowStepSsa(v, pos, mid, d1, upper, r1) and
      bounded(mid, b, d2, upper, fromBackEdge, origdelta, r2) and
      // upper = true:  v <= mid + d1 <= b + d1 + d2 = b + delta
      // upper = false: v >= mid + d1 >= b + d1 + d2 = b + delta
      delta = D::fromFloat(D::toFloat(d1) + D::toFloat(d2)) and
      (if r1 instanceof SemNoReason then reason = r2 else reason = r1)
    )
    or
    exists(D::Delta d, SemReason r1, SemReason r2 |
      boundedSsa(pragma[only_bind_into](v), pragma[only_bind_into](b), pragma[only_bind_into](d),
        pragma[only_bind_into](pos), upper, fromBackEdge, origdelta, r2)
      or
      boundedPhi(pragma[only_bind_into](v), pragma[only_bind_into](b), pragma[only_bind_into](d),
        upper, fromBackEdge, origdelta, r2)
    |
      unequalIntegralSsa(v, b, d, pos, r1) and
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
    Sem::SsaVariable v, SemBound b, D::Delta delta, Sem::SsaReadPosition pos, SemReason reason
  ) {
    exists(Sem::Expr e, D::Delta d1, D::Delta d2 |
      unequalFlowStepIntegralSsa(v, pos, e, d1, reason) and
      boundedUpper(e, b, d2) and
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
  private predicate boundedUpper(Sem::Expr e, SemBound b, D::Delta delta) {
    bounded(e, b, delta, true, _, _, _)
  }

  /**
   * Holds if `b + delta` is a lower bound for `e`.
   *
   * This predicate only exists to prevent a bad standard order in `unequalIntegralSsa`.
   */
  pragma[nomagic]
  private predicate boundedLower(Sem::Expr e, SemBound b, D::Delta delta) {
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
    Sem::SsaPhiNode phi, Sem::SsaVariable inp, Sem::SsaReadPositionPhiInputEdge edge, SemBound b,
    D::Delta delta, boolean upper, boolean fromBackEdge, D::Delta origdelta, SemReason reason
  ) {
    edge.phiInput(phi, inp) and
    exists(D::Delta d, boolean fromBackEdge0 |
      boundedSsa(inp, b, d, edge, upper, fromBackEdge0, origdelta, reason)
      or
      boundedPhi(inp, b, d, upper, fromBackEdge0, origdelta, reason)
      or
      b.(SemSsaBound).getVariable() = inp and
      d = D::fromFloat(0) and
      (upper = true or upper = false) and
      fromBackEdge0 = false and
      origdelta = D::fromFloat(0) and
      reason = TSemNoReason()
    |
      if Sem::backEdge(phi, inp, edge)
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
    Sem::SsaPhiNode phi, SemBound b, boolean upper, Sem::SsaVariable inp,
    Sem::SsaReadPositionPhiInputEdge edge, D::Delta delta
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
    Sem::SsaPhiNode phi, Sem::SsaVariable inp, Sem::SsaReadPositionPhiInputEdge edge, boolean upper
  ) {
    exists(D::Delta d, SemSsaBound phibound |
      phibound.getVariable() = phi and
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
    Sem::SsaPhiNode phi, boolean upper, SemBound b, D::Delta delta, boolean fromBackEdge,
    D::Delta origdelta, SemReason reason
  ) {
    boundedPhiInp(phi, _, _, b, delta, upper, fromBackEdge, origdelta, reason)
  }

  /**
   * Holds if the candidate bound `b + delta` for `phi` is valid for the phi input
   * `inp` along `edge`.
   */
  private predicate boundedPhiCandValidForEdge(
    Sem::SsaPhiNode phi, SemBound b, D::Delta delta, boolean upper, boolean fromBackEdge,
    D::Delta origdelta, SemReason reason, Sem::SsaVariable inp,
    Sem::SsaReadPositionPhiInputEdge edge
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
   * Holds if `b + delta` is a valid bound for `phi`'s `rix`th input edge.
   * - `upper = true`  : `phi <= b + delta`
   * - `upper = false` : `phi >= b + delta`
   */
  pragma[nomagic]
  private predicate boundedPhiRankStep(
    Sem::SsaPhiNode phi, SemBound b, D::Delta delta, boolean upper, boolean fromBackEdge,
    D::Delta origdelta, SemReason reason, int rix
  ) {
    exists(Sem::SsaVariable inp, Sem::SsaReadPositionPhiInputEdge edge |
      rankedPhiInput(phi, inp, edge, rix) and
      boundedPhiCandValidForEdge(phi, b, delta, upper, fromBackEdge, origdelta, reason, inp, edge)
    |
      rix = 1
      or
      boundedPhiRankStep(phi, b, delta, upper, fromBackEdge, origdelta, reason, rix - 1)
    )
  }

  /**
   * Holds if `b + delta` is a valid bound for `phi`.
   * - `upper = true`  : `phi <= b + delta`
   * - `upper = false` : `phi >= b + delta`
   */
  private predicate boundedPhi(
    Sem::SsaPhiNode phi, SemBound b, D::Delta delta, boolean upper, boolean fromBackEdge,
    D::Delta origdelta, SemReason reason
  ) {
    exists(int r |
      maxPhiInputRank(phi, r) and
      boundedPhiRankStep(phi, b, delta, upper, fromBackEdge, origdelta, reason, r)
    )
  }

  /**
   * Holds if `e` has an upper (for `upper = true`) or lower
   * (for `upper = false`) bound of `b`.
   */
  private predicate baseBound(Sem::Expr e, D::Delta b, boolean upper) {
    hasConstantBound(e, b, upper)
    or
    upper = false and
    b = D::fromInt(0) and
    semPositive(e.(Sem::BitAndExpr).getAnOperand())
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

  pragma[nomagic]
  private predicate initialBoundedUpper(Sem::Expr e) {
    exists(D::Delta d |
      initialBounded(e, _, d, false, _, _, _) and
      D::toFloat(d) >= 0
    )
  }

  private predicate noOverflow0(Sem::Expr e, boolean upper) {
    exists(boolean lower | lower = upper.booleanNot() |
      semExprDoesNotOverflow(lower, e)
      or
      upper = [true, false] and
      not potentiallyOverflowingExpr(lower, e)
    )
  }

  pragma[nomagic]
  private predicate initialBoundedLower(Sem::Expr e) {
    exists(D::Delta d |
      initialBounded(e, _, d, true, _, _, _) and
      D::toFloat(d) <= 0
    )
  }

  pragma[nomagic]
  private predicate noOverflow(Sem::Expr e, boolean upper) {
    noOverflow0(e, upper)
    or
    upper = true and initialBoundedUpper(e)
    or
    upper = false and initialBoundedLower(e)
  }

  predicate bounded(
    Sem::Expr e, SemBound b, D::Delta delta, boolean upper, boolean fromBackEdge,
    D::Delta origdelta, SemReason reason
  ) {
    initialBounded(e, b, delta, upper, fromBackEdge, origdelta, reason) and
    noOverflow(e, upper)
  }

  predicate potentiallyOverflowingExpr(boolean positively, Sem::Expr expr) {
    positively = true and
    semMayBePositive(expr.(Sem::AddExpr).getLeftOperand()) and
    semMayBePositive(expr.(Sem::AddExpr).getRightOperand())
    or
    positively = false and
    semMayBeNegative(expr.(Sem::AddExpr).getLeftOperand()) and
    semMayBeNegative(expr.(Sem::AddExpr).getRightOperand())
    or
    positively = true and
    semMayBePositive(expr.(Sem::SubExpr).getLeftOperand()) and
    semMayBeNegative(expr.(Sem::SubExpr).getRightOperand())
    or
    positively = false and
    semMayBeNegative(expr.(Sem::SubExpr).getLeftOperand()) and
    semMayBePositive(expr.(Sem::SubExpr).getRightOperand())
    or
    positively in [true, false] and
    (
      expr instanceof Sem::MulExpr or
      expr instanceof Sem::ShiftLeftExpr
    )
    or
    positively = false and
    (
      expr instanceof Sem::NegateExpr or
      expr instanceof Sem::PreDecExpr or
      getTrackedType(expr.(Sem::DivExpr)) instanceof Sem::FloatingPointType
    )
    or
    positively = true and
    expr instanceof Sem::PreIncExpr
  }

  /**
   * Computes a normal form of `x` where -0.0 has changed to +0.0. This can be
   * needed on the lesser side of a floating-point comparison or on both sides of
   * a floating point equality because QL does not follow IEEE in floating-point
   * comparisons but instead defines -0.0 to be less than and distinct from 0.0.
   */
  bindingset[x]
  private float normalizeFloatUp(float x) { result = x + 0.0 }

  bindingset[x, y]
  private float truncatingDiv(float x, float y) { result = (x - (x % y)) / y }

  /**
   * Holds if `b + delta` is a valid bound for `e`.
   * - `upper = true`  : `e <= b + delta`
   * - `upper = false` : `e >= b + delta`
   */
  predicate initialBounded(
    Sem::Expr e, SemBound b, D::Delta delta, boolean upper, boolean fromBackEdge,
    D::Delta origdelta, SemReason reason
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
      exists(Sem::SsaVariable v, Sem::SsaReadPositionBlock bb |
        boundedSsa(v, b, delta, bb, upper, fromBackEdge, origdelta, reason) and
        e = v.getAUse() and
        bb.getBlock() = e.getBasicBlock()
      )
      or
      exists(Sem::Expr mid, D::Delta d1, D::Delta d2 |
        boundFlowStep(e, mid, d1, upper) and
        // Constants have easy, base-case bounds, so let's not infer any recursive bounds.
        not e instanceof Sem::ConstantIntegerExpr and
        bounded(mid, b, d2, upper, fromBackEdge, origdelta, reason) and
        // upper = true:  e <= mid + d1 <= b + d1 + d2 = b + delta
        // upper = false: e >= mid + d1 >= b + d1 + d2 = b + delta
        delta = D::fromFloat(D::toFloat(d1) + D::toFloat(d2))
      )
      or
      exists(Sem::SsaPhiNode phi |
        boundedPhi(phi, b, delta, upper, fromBackEdge, origdelta, reason) and
        e = phi.getAUse()
      )
      or
      exists(Sem::Expr mid, D::Delta factor, D::Delta d |
        boundFlowStepMul(e, mid, factor) and
        not e instanceof Sem::ConstantIntegerExpr and
        bounded(mid, b, d, upper, fromBackEdge, origdelta, reason) and
        b instanceof SemZeroBound and
        delta = D::fromFloat(D::toFloat(d) * D::toFloat(factor))
      )
      or
      exists(Sem::Expr mid, D::Delta factor, D::Delta d |
        boundFlowStepDiv(e, mid, factor) and
        not e instanceof Sem::ConstantIntegerExpr and
        bounded(mid, b, d, upper, fromBackEdge, origdelta, reason) and
        b instanceof SemZeroBound and
        D::toFloat(d) >= 0 and
        delta = D::fromFloat(truncatingDiv(D::toFloat(d), D::toFloat(factor)))
      )
      or
      exists(NarrowingCastExpr cast |
        cast = e and
        safeNarrowingCast(cast, upper.booleanNot()) and
        boundedCastExpr(cast, b, delta, upper, fromBackEdge, origdelta, reason)
      )
      or
      exists(
        Sem::ConditionalExpr cond, D::Delta d1, D::Delta d2, boolean fbe1, boolean fbe2,
        D::Delta od1, D::Delta od2, SemReason r1, SemReason r2
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
      not javaCompatibility() and
      exists(Sem::Expr mid, D::Delta d, float f |
        e.(Sem::NegateExpr).getOperand() = mid and
        b instanceof SemZeroBound and
        bounded(mid, b, d, upper.booleanNot(), fromBackEdge, origdelta, reason) and
        f = normalizeFloatUp(-D::toFloat(d)) and
        delta = D::fromFloat(f) and
        if semPositive(e) then f >= 0 else any()
      )
      or
      exists(
        SemBound bLeft, SemBound bRight, D::Delta dLeft, D::Delta dRight, boolean fbeLeft,
        boolean fbeRight, D::Delta odLeft, D::Delta odRight, SemReason rLeft, SemReason rRight
      |
        boundedAddOperand(e, upper, bLeft, false, dLeft, fbeLeft, odLeft, rLeft) and
        boundedAddOperand(e, upper, bRight, true, dRight, fbeRight, odRight, rRight) and
        delta = D::fromFloat(D::toFloat(dLeft) + D::toFloat(dRight)) and
        fromBackEdge = fbeLeft.booleanOr(fbeRight)
      |
        b = bLeft and origdelta = odLeft and reason = rLeft and bRight instanceof SemZeroBound
        or
        b = bRight and origdelta = odRight and reason = rRight and bLeft instanceof SemZeroBound
      )
      or
      not javaCompatibility() and
      exists(D::Delta dLeft, D::Delta dRight, boolean fbeLeft, boolean fbeRight |
        boundedSubOperandLeft(e, upper, b, dLeft, fbeLeft, origdelta, reason) and
        boundedSubOperandRight(e, upper, dRight, fbeRight) and
        // when `upper` is `true` we have:
        // left <= b + dLeft
        // right >= 0 + dRight
        // left - right <= b + dLeft - (0 + dRight)
        //               = b + (dLeft - dRight)
        // and when `upper` is `false` we have:
        // left >= b + dLeft
        // right <= 0 + dRight
        // left - right >= b + dLeft - (0 + dRight)
        //               = b + (dLeft - dRight)
        delta = D::fromFloat(D::toFloat(dLeft) - D::toFloat(dRight)) and
        fromBackEdge = fbeLeft.booleanOr(fbeRight)
      )
      or
      not javaCompatibility() and
      exists(
        Sem::RemExpr rem, D::Delta d_max, D::Delta d1, D::Delta d2, boolean fbe1, boolean fbe2,
        D::Delta od1, D::Delta od2, SemReason r1, SemReason r2
      |
        rem = e and
        b instanceof SemZeroBound and
        not (upper = true and semPositive(rem.getRightOperand())) and
        not (upper = true and semPositive(rem.getLeftOperand())) and
        boundedRemExpr(rem, true, d1, fbe1, od1, r1) and
        boundedRemExpr(rem, false, d2, fbe2, od2, r2) and
        (
          if D::toFloat(d1).abs() > D::toFloat(d2).abs()
          then (
            d_max = d1 and fromBackEdge = fbe1 and origdelta = od1 and reason = r1
          ) else (
            d_max = d2 and fromBackEdge = fbe2 and origdelta = od2 and reason = r2
          )
        )
      |
        upper = true and delta = D::fromFloat(D::toFloat(d_max).abs() - 1)
        or
        upper = false and delta = D::fromFloat(-D::toFloat(d_max).abs() + 1)
      )
      or
      not javaCompatibility() and
      exists(
        D::Delta dLeft, D::Delta dRight, boolean fbeLeft, boolean fbeRight, D::Delta odLeft,
        D::Delta odRight, SemReason rLeft, SemReason rRight
      |
        boundedMulOperand(e, upper, true, dLeft, fbeLeft, odLeft, rLeft) and
        boundedMulOperand(e, upper, false, dRight, fbeRight, odRight, rRight) and
        delta = D::fromFloat(D::toFloat(dLeft) * D::toFloat(dRight)) and
        fromBackEdge = fbeLeft.booleanOr(fbeRight)
      |
        b instanceof SemZeroBound and origdelta = odLeft and reason = rLeft
        or
        b instanceof SemZeroBound and origdelta = odRight and reason = rRight
      )
    )
  }

  pragma[nomagic]
  private predicate boundedConditionalExpr(
    Sem::ConditionalExpr cond, SemBound b, boolean upper, boolean branch, D::Delta delta,
    boolean fromBackEdge, D::Delta origdelta, SemReason reason
  ) {
    bounded(cond.getBranchExpr(branch), b, delta, upper, fromBackEdge, origdelta, reason)
  }

  pragma[nomagic]
  private predicate boundedAddOperand(
    Sem::AddExpr add, boolean upper, SemBound b, boolean isLeft, D::Delta delta,
    boolean fromBackEdge, D::Delta origdelta, SemReason reason
  ) {
    // `semValueFlowStep` already handles the case where one of the operands is a constant.
    not semValueFlowStep(add, _, _) and
    (
      isLeft = true and
      bounded(add.getLeftOperand(), b, delta, upper, fromBackEdge, origdelta, reason)
      or
      isLeft = false and
      bounded(add.getRightOperand(), b, delta, upper, fromBackEdge, origdelta, reason)
    )
  }

  /**
   * Holds if `sub = left - right` and `left <= b + delta` if `upper` is `true`
   * and `left >= b + delta` is `upper` is `false`.
   */
  pragma[nomagic]
  private predicate boundedSubOperandLeft(
    Sem::SubExpr sub, boolean upper, SemBound b, D::Delta delta, boolean fromBackEdge,
    D::Delta origdelta, SemReason reason
  ) {
    // `semValueFlowStep` already handles the case where one of the operands is a constant.
    not semValueFlowStep(sub, _, _) and
    bounded(sub.getLeftOperand(), b, delta, upper, fromBackEdge, origdelta, reason)
  }

  /**
   * Holds if `sub = left - right` and `right <= 0 + delta` if `upper` is `false`
   * and `right >= 0 + delta` is `upper` is `true`.
   *
   * Note that the boolean value of `upper` is flipped compared to many other predicates in
   * this file. This ensures a clean join at the call-site.
   */
  pragma[nomagic]
  private predicate boundedSubOperandRight(
    Sem::SubExpr sub, boolean upper, D::Delta delta, boolean fromBackEdge
  ) {
    // `semValueFlowStep` already handles the case where one of the operands is a constant.
    not semValueFlowStep(sub, _, _) and
    bounded(sub.getRightOperand(), any(SemZeroBound zb), delta, upper.booleanNot(), fromBackEdge, _,
      _)
  }

  pragma[nomagic]
  private predicate boundedRemExpr(
    Sem::RemExpr rem, boolean upper, D::Delta delta, boolean fromBackEdge, D::Delta origdelta,
    SemReason reason
  ) {
    bounded(rem.getRightOperand(), any(SemZeroBound zb), delta, upper, fromBackEdge, origdelta,
      reason)
  }

  /**
   * Define `cmp(true) = <=` and `cmp(false) = >=`.
   *
   * Holds if `mul = left * right`, and in order to know if `mul cmp(upper) 0 + k` (for
   * some `k`) we need to know that `left cmp(upperLeft) 0 + k1` and
   * `right cmp(upperRight) 0 + k2` (for some `k1` and `k2`).
   */
  pragma[nomagic]
  private predicate boundedMulOperandCand(
    Sem::MulExpr mul, Sem::Expr left, Sem::Expr right, boolean upper, boolean upperLeft,
    boolean upperRight
  ) {
    not boundFlowStepMul(mul, _, _) and
    mul.getLeftOperand() = left and
    mul.getRightOperand() = right and
    (
      semPositive(left) and
      (
        // left, right >= 0
        semPositive(right) and
        (
          // max(left * right) = max(left) * max(right)
          upper = true and
          upperLeft = true and
          upperRight = true
          or
          // min(left * right) = min(left) * min(right)
          upper = false and
          upperLeft = false and
          upperRight = false
        )
        or
        // left >= 0, right <= 0
        semNegative(right) and
        (
          // max(left * right) = min(left) * max(right)
          upper = true and
          upperLeft = false and
          upperRight = true
          or
          // min(left * right) = max(left) * min(right)
          upper = false and
          upperLeft = true and
          upperRight = false
        )
      )
      or
      semNegative(left) and
      (
        // left <= 0, right >= 0
        semPositive(right) and
        (
          // max(left * right) = max(left) * min(right)
          upper = true and
          upperLeft = true and
          upperRight = false
          or
          // min(left * right) = min(left) * max(right)
          upper = false and
          upperLeft = false and
          upperRight = true
        )
        or
        // left, right <= 0
        semNegative(right) and
        (
          // max(left * right) = min(left) * min(right)
          upper = true and
          upperLeft = false and
          upperRight = false
          or
          // min(left * right) = max(left) * max(right)
          upper = false and
          upperLeft = true and
          upperRight = true
        )
      )
    )
  }

  /**
   * Holds if `isLeft = true` and `mul`'s left operand is bounded by `delta`,
   * or if `isLeft = false` and `mul`'s right operand is bounded by `delta`.
   *
   * If `upper = true` the computed bound contributes to an upper bound of `mul`,
   * and if `upper = false` it contributes to a lower bound.
   * The `fromBackEdge`, `origdelta`, `reason` triple are defined by the recursive
   * call to `bounded`.
   */
  pragma[nomagic]
  private predicate boundedMulOperand(
    Sem::MulExpr mul, boolean upper, boolean isLeft, D::Delta delta, boolean fromBackEdge,
    D::Delta origdelta, SemReason reason
  ) {
    exists(boolean upperLeft, boolean upperRight, Sem::Expr left, Sem::Expr right |
      boundedMulOperandCand(mul, left, right, upper, upperLeft, upperRight)
    |
      isLeft = true and
      bounded(left, any(SemZeroBound zb), delta, upperLeft, fromBackEdge, origdelta, reason)
      or
      isLeft = false and
      bounded(right, any(SemZeroBound zb), delta, upperRight, fromBackEdge, origdelta, reason)
    )
  }
}
