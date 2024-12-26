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
    QlBuiltins::BigInt getIntValue();
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

  class BasicBlock {
    /** Holds if this block (transitively) dominates `otherblock`. */
    predicate bbDominates(BasicBlock otherBlock);
  }

  /** Gets an immediate successor of basic block `bb`, if any. */
  BasicBlock getABasicBlockSuccessor(BasicBlock bb);

  /**
   * Gets an ideally unique integer for `bb`. If it is undesirable to make this
   * unique, then `getBlock2` must provide a tiebreaker, such that the pair
   * `(getBlockId1(bb),getBlockId2(bb))` becomes unique.
   */
  int getBlockId1(BasicBlock bb);

  /** Gets a tiebreaker id in case `getBlockId1` is not unique. */
  default string getBlockId2(BasicBlock bb) { result = "" }

  /**
   * A guard in the range analysis.
   */
  class Guard {
    /**
     * Gets a string representation of the guard.
     */
    string toString();

    /**
     * Gets the basic block associated with the guard.
     */
    BasicBlock getBasicBlock();

    /**
     * Gets the guard as an expression, if any.
     */
    Expr asExpr();

    /**
     * Holds if the guard directly controls a given basic block. For example in
     * the following code, the guard `(x > y)` directly controls the block
     * beneath it:
     * ```
     * if (x > y)
     * {
     *   Console.WriteLine("x is greater than y");
     * }
     * ```
     * `branch` indicates whether the basic block is entered when the guard
     * evaluates to `true` or when it evaluates to `false`.
     */
    predicate directlyControls(BasicBlock controlled, boolean branch);

    /**
     * Holds if this guard is an equality test between `e1` and `e2`. If the
     * test is negated, that is `!=`, then `polarity` is false, otherwise
     * `polarity` is true.
     */
    predicate isEquality(Expr e1, Expr e2, boolean polarity);

    /**
     * Holds if there is a branch edge between two basic blocks. For example
     * in the following C code, there are two branch edges from the basic block
     * containing the condition `(x > y)` to the beginnings of the true and
     * false blocks that follow:
     * ```
     * if (x > y) {
     *   printf("x is greater than y\n");
     * } else {
     *   printf("x is not greater than y\n");
     * }
     * ```
     * `branch` indicates whether the second basic block is the one entered
     * when the guard evaluates to `true` or when it evaluates to `false`.
     */
    predicate hasBranchEdge(BasicBlock bb1, BasicBlock bb2, boolean branch);
  }

  predicate implies_v2(Guard g1, boolean b1, Guard g2, boolean b2);

  class Type;

  class IntegerType extends Type {
    predicate isSigned();

    int getByteSize();
  }

  class FloatingPointType extends Type;

  class AddressType extends Type;

  /** Gets the type of an SSA variable. */
  Type getSsaType(SsaVariable var);

  /** Gets the type of an expression. */
  Type getExprType(Expr e);

  /**
   * A static single-assignment (SSA) variable.
   */
  class SsaVariable {
    /**
     * Gets an expression reading the value of this SSA variable.
     */
    Expr getAUse();

    /**
     * Gets the basic block where this SSA variable is defined.
     */
    BasicBlock getBasicBlock();
  }

  /**
   * A phi node in the SSA form. A phi node is a kind of node in the SSA form
   * that represents a merge point where multiple control flow paths converge
   * and the value of a variable needs to be selected according to which
   * control flow path was taken. For example, in the following Ruby code:
   * ```rb
   * if b
   *   x = 0
   * else
   *   x = 1
   * end
   * puts x
   * ```
   * A phi node for `x` is inserted just before the call `puts x`, since the
   * value of `x` may come from either `x = 0` or `x = 1`.
   */
  class SsaPhiNode extends SsaVariable {
    /** Holds if `inp` is an input to the phi node along the edge originating in `bb`. */
    predicate hasInputFromBlock(SsaVariable inp, BasicBlock bb);
  }

  /**
   * An SSA variable representing the value of an explicit update of the source variable.
   */
  class SsaExplicitUpdate extends SsaVariable {
    /**
     * Gets the expression that defines the value of the variable in this
     * update.
     */
    Expr getDefiningExpr();
  }

  /**
   * Holds if the value of `dest` is known to be `src + delta`.
   */
  predicate additionalValueFlowStep(Expr dest, Expr src, QlBuiltins::BigInt delta);

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

  predicate exprModulus(Sem::Expr e, ModBound b, QlBuiltins::BigInt val, QlBuiltins::BigInt mod);
}

signature module LangSig<Semantic Sem> {
  /**
   * Holds if `e >= bound` (if `upper = false`) or `e <= bound` (if `upper = true`).
   */
  predicate hasConstantBound(Sem::Expr e, QlBuiltins::BigInt bound, boolean upper);

  /**
   * Holds if `e2 >= e1 + delta` (if `upper = false`) or `e2 <= e1 + delta` (if `upper = true`).
   */
  predicate additionalBoundFlowStep(
    Sem::Expr e2, Sem::Expr e1, QlBuiltins::BigInt delta, boolean upper
  );

  /**
   * Ignore the bound on this expression.
   *
   * This predicate is to keep the results identical to the original Java implementation. It should be
   * removed once we have the new implementation matching the old results exactly.
   */
  predicate ignoreExprBound(Sem::Expr e);

  default predicate javaCompatibility() { none() }

  default predicate includeConstantBounds() { any() }

  default predicate includeRelativeBounds() { any() }
}

signature module BoundSig<LocationSig Location, Semantic Sem> {
  /**
   * A bound that the range analysis can infer for a variable. This includes
   * constant bounds represented by the abstract value zero, SSA bounds for when
   * a variable is bounded by the value of a different variable, and possibly
   * other abstract values that may be useful variable bounds. Since all bounds
   * are combined with an integer delta there's no need to represent constant
   * bounds other than zero.
   */
  class SemBound {
    /**
     * Gets a string representation of this bound.
     */
    string toString();

    /**
     * Gets the location of this bound.
     */
    Location getLocation();

    /**
     * Gets an expression that equals this bound plus `delta`.
     *
     * For the zero-bound this gets integer constants equal to `delta`, for any
     * value `delta`. For other bounds this gets expressions equal to the bound
     * and `delta = 0`.
     */
    Sem::Expr getExpr(QlBuiltins::BigInt delta);
  }

  class SemZeroBound extends SemBound;

  class SemSsaBound extends SemBound {
    Sem::SsaVariable getVariable();
  }
}

signature module OverflowSig<Semantic Sem> {
  predicate semExprDoesNotOverflow(boolean positively, Sem::Expr expr);
}

module RangeStage<
  LocationSig Location, Semantic Sem, BoundSig<Location, Sem> Bounds,
  OverflowSig<Sem> OverflowParam, LangSig<Sem> LangParam, SignAnalysisSig<Sem> SignAnalysis,
  ModulusAnalysisSig<Sem> ModulusAnalysisParam>
{
  private import Bounds
  private import LangParam
  private import OverflowParam
  private import SignAnalysis
  private import ModulusAnalysisParam
  private import internal.RangeUtils::MakeUtils<Sem>

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
      Sem::conversionCannotOverflow(Sem::getExprType(pragma[only_bind_into](this.getOperand())),
        pragma[only_bind_out](Sem::getExprType(this)))
    }
  }

  /**
   * A cast to a small integral type that may overflow or underflow.
   */
  private class NarrowingCastExpr extends ConvertOrBoxExpr {
    NarrowingCastExpr() {
      not this instanceof SafeCastExpr and
      typeBound(Sem::getExprType(this), _, _)
    }

    /** Gets the lower bound of the resulting type. */
    float getLowerBound() { typeBound(Sem::getExprType(this), result, _) }

    /** Gets the upper bound of the resulting type. */
    float getUpperBound() { typeBound(Sem::getExprType(this), _, result) }
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
      predicate semBounded(
        Sem::Expr e, SemBound b, QlBuiltins::BigInt delta, boolean upper, SemReason reason
      ) {
        bounded(e, b, delta, upper, _, _, reason) and
        bestBound(e, b, delta, upper)
      }
    }

    /**
     * Holds if `guard = boundFlowCond(_, _, _, _, _) or guard = eqFlowCond(_, _, _, _, _)`.
     */
    cached
    predicate possibleReason(Sem::Guard guard) {
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
  private predicate bestBound(Sem::Expr e, SemBound b, QlBuiltins::BigInt delta, boolean upper) {
    delta = min(QlBuiltins::BigInt d | bounded(e, b, d, upper, _, _, _) | d) and
    upper = true
    or
    delta = max(QlBuiltins::BigInt d | bounded(e, b, d, upper, _, _, _) | d) and
    upper = false
  }

  /**
   * Holds if `comp` corresponds to:
   * - `upper = true`  : `v <= e + delta` or `v < e + delta`
   * - `upper = false` : `v >= e + delta` or `v > e + delta`
   */
  private predicate boundCondition(
    Sem::RelationalExpr comp, Sem::SsaVariable v, Sem::Expr e, QlBuiltins::BigInt delta,
    boolean upper
  ) {
    comp.getLesserOperand() = ssaRead(v, delta) and
    e = comp.getGreaterOperand() and
    upper = true
    or
    comp.getGreaterOperand() = ssaRead(v, delta) and
    e = comp.getLesserOperand() and
    upper = false
    or
    exists(Sem::SubExpr sub, Sem::ConstantIntegerExpr c, QlBuiltins::BigInt d |
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
  private predicate modulusComparison(
    Sem::RelationalExpr comp, boolean testIsTrue, QlBuiltins::BigInt strengthen
  ) {
    exists(
      ModBound b, QlBuiltins::BigInt v1, QlBuiltins::BigInt v2, QlBuiltins::BigInt mod1,
      QlBuiltins::BigInt mod2, QlBuiltins::BigInt mod, boolean resultIsStrict, QlBuiltins::BigInt d,
      QlBuiltins::BigInt k
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
      mod != 1.toBigInt() and
      (testIsTrue = true or testIsTrue = false) and
      (
        if comp.isStrict()
        then resultIsStrict = testIsTrue
        else resultIsStrict = testIsTrue.booleanNot()
      ) and
      (
        resultIsStrict = true and d = 1.toBigInt()
        or
        resultIsStrict = false and d = 0.toBigInt()
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
    Sem::SsaVariable v, Sem::Expr e, QlBuiltins::BigInt delta, boolean upper, boolean testIsTrue
  ) {
    exists(
      Sem::RelationalExpr comp, QlBuiltins::BigInt d1, QlBuiltins::BigInt d2, QlBuiltins::BigInt d3,
      int strengthen, boolean compIsUpper, boolean resultIsStrict
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
          Sem::getSsaType(v) instanceof Sem::IntegerType or
          Sem::getSsaType(v) instanceof Sem::AddressType
        then
          upper = true and strengthen = -1
          or
          upper = false and strengthen = 1
        else strengthen = 0
      ) and
      (
        exists(QlBuiltins::BigInt k |
          modulusComparison(comp, testIsTrue, k) and d2 = strengthen.toBigInt() * k
        )
        or
        not modulusComparison(comp, testIsTrue, _) and d2 = 0.toBigInt()
      ) and
      // A strict inequality `x < y` can be strengthened to `x <= y - 1`.
      (
        resultIsStrict = true and d3 = strengthen.toBigInt()
        or
        resultIsStrict = false and d3 = 0.toBigInt()
      ) and
      delta = d1 + d2 + d3
    )
    or
    exists(boolean testIsTrue0 |
      Sem::implies_v2(result, testIsTrue, boundFlowCond(v, e, delta, upper, testIsTrue0),
        testIsTrue0)
    )
    or
    result = eqFlowCond(v, e, delta, true, testIsTrue) and
    (upper = true or upper = false)
    or
    // guard that tests whether `v2` is bounded by `e + delta + d1 - d2` and
    // exists a guard `guardEq` such that `v = v2 - d1 + d2`.
    exists(Sem::SsaVariable v2, QlBuiltins::BigInt oldDelta, QlBuiltins::BigInt d |
      // equality needs to control guard
      result.getBasicBlock() = eqSsaCondDirectlyControls(v, v2, d) and
      result = boundFlowCond(v2, e, oldDelta, upper, testIsTrue) and
      delta = oldDelta + d
    )
  }

  /**
   * Gets a basic block in which `v1` equals `v2 + delta`.
   */
  pragma[nomagic]
  private Sem::BasicBlock eqSsaCondDirectlyControls(
    Sem::SsaVariable v1, Sem::SsaVariable v2, QlBuiltins::BigInt delta
  ) {
    exists(Sem::Guard guardEq, QlBuiltins::BigInt d1, QlBuiltins::BigInt d2, boolean eqIsTrue |
      guardEq = eqFlowCond(v1, ssaRead(v2, d1), d2, true, eqIsTrue) and
      delta = d2 - d1 and
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
    Sem::SsaVariable v, SsaReadPosition pos, Sem::Expr e, QlBuiltins::BigInt delta, boolean upper,
    SemReason reason
  ) {
    ssaUpdateStep(v, e, delta) and
    pos.hasReadOfVar(v) and
    (upper = true or upper = false) and
    reason = TSemNoReason()
    or
    exists(Sem::Guard guard, boolean testIsTrue |
      pos.hasReadOfVar(v) and
      guard = boundFlowCond(v, e, delta, upper, testIsTrue) and
      guardDirectlyControlsSsaRead(guard, pos, testIsTrue) and
      reason = TSemCondReason(guard)
    )
  }

  /** Holds if `v != e + delta` at `pos` and `v` is of integral type. */
  private predicate unequalFlowStepIntegralSsa(
    Sem::SsaVariable v, SsaReadPosition pos, Sem::Expr e, QlBuiltins::BigInt delta, SemReason reason
  ) {
    Sem::getSsaType(v) instanceof Sem::IntegerType and
    exists(Sem::Guard guard, boolean testIsTrue |
      pos.hasReadOfVar(v) and
      guard = eqFlowCond(v, e, delta, false, testIsTrue) and
      guardDirectlyControlsSsaRead(guard, pos, testIsTrue) and
      reason = TSemCondReason(guard)
    )
  }

  /** Holds if `e >= 1` as determined by sign analysis. */
  private predicate strictlyPositiveIntegralExpr(Sem::Expr e) {
    semStrictlyPositive(e) and Sem::getExprType(e) instanceof Sem::IntegerType
  }

  /** Holds if `e <= -1` as determined by sign analysis. */
  private predicate strictlyNegativeIntegralExpr(Sem::Expr e) {
    semStrictlyNegative(e) and Sem::getExprType(e) instanceof Sem::IntegerType
  }

  /**
   * Holds if `e1 + delta` is a valid bound for `e2`.
   * - `upper = true`  : `e2 <= e1 + delta`
   * - `upper = false` : `e2 >= e1 + delta`
   */
  private predicate boundFlowStep(
    Sem::Expr e2, Sem::Expr e1, QlBuiltins::BigInt delta, boolean upper
  ) {
    // Constants have easy, base-case bounds, so let's not infer any recursive bounds.
    not e2 instanceof Sem::ConstantIntegerExpr and
    (
      valueFlowStep(e2, e1, delta) and
      upper = [true, false]
      or
      e2.(SafeCastExpr).getOperand() = e1 and
      delta = 0.toBigInt() and
      upper = [true, false]
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
        then upper = true and delta = -1.toBigInt()
        else
          if semPositive(x)
          then upper = true and delta = 0.toBigInt()
          else
            if strictlyNegativeIntegralExpr(x)
            then upper = false and delta = 1.toBigInt()
            else
              if semNegative(x)
              then upper = false and delta = 0.toBigInt()
              else none()
      )
      or
      e2.(Sem::RemExpr).getRightOperand() = e1 and
      semPositive(e1) and
      delta = -1.toBigInt() and
      upper = true
      or
      e2.(Sem::RemExpr).getLeftOperand() = e1 and
      semPositive(e1) and
      delta = 0.toBigInt() and
      upper = true
      or
      e2.(Sem::BitAndExpr).getAnOperand() = e1 and
      semPositive(e1) and
      delta = 0.toBigInt() and
      upper = true
      or
      e2.(Sem::BitOrExpr).getAnOperand() = e1 and
      semPositive(e2) and
      delta = 0.toBigInt() and
      upper = false
      or
      additionalBoundFlowStep(e2, e1, delta, upper)
    )
  }

  /** Holds if `e2 = e1 * factor` and `factor > 0`. */
  private predicate boundFlowStepMul(Sem::Expr e2, Sem::Expr e1, QlBuiltins::BigInt factor) {
    not e2 instanceof Sem::ConstantIntegerExpr and
    exists(Sem::ConstantIntegerExpr c, QlBuiltins::BigInt k |
      k = c.getIntValue() and k > 0.toBigInt()
    |
      e2.(Sem::MulExpr).hasOperands(e1, c) and factor = k
      or
      exists(Sem::ShiftLeftExpr e |
        e = e2 and
        e.getLeftOperand() = e1 and
        e.getRightOperand() = c and
        factor = 2.toBigInt().pow(k.toInt())
      )
    )
  }

  /**
   * Holds if `e2 = e1 / factor` and `factor > 0`.
   *
   * This conflates division, right shift, and unsigned right shift and is
   * therefore only valid for non-negative numbers.
   */
  private predicate boundFlowStepDiv(Sem::Expr e2, Sem::Expr e1, QlBuiltins::BigInt factor) {
    not e2 instanceof Sem::ConstantIntegerExpr and
    Sem::getExprType(e2) instanceof Sem::IntegerType and
    exists(Sem::ConstantIntegerExpr c, QlBuiltins::BigInt k |
      k = c.getIntValue() and k > 0.toBigInt()
    |
      exists(Sem::DivExpr e |
        e = e2 and e.getLeftOperand() = e1 and e.getRightOperand() = c and factor = k
      )
      or
      exists(Sem::ShiftRightExpr e |
        e = e2 and
        e.getLeftOperand() = e1 and
        e.getRightOperand() = c and
        factor = 2.toBigInt().pow(k.toInt())
      )
      or
      exists(Sem::ShiftRightUnsignedExpr e |
        e = e2 and
        e.getLeftOperand() = e1 and
        e.getRightOperand() = c and
        factor = 2.toBigInt().pow(k.toInt())
      )
    )
  }

  /**
   * Holds if `b + delta` is a valid bound for `v` at `pos`.
   * - `upper = true`  : `v <= b + delta`
   * - `upper = false` : `v >= b + delta`
   */
  private predicate boundedSsa(
    Sem::SsaVariable v, SemBound b, QlBuiltins::BigInt delta, SsaReadPosition pos, boolean upper,
    boolean fromBackEdge, QlBuiltins::BigInt origdelta, SemReason reason
  ) {
    exists(Sem::Expr mid, QlBuiltins::BigInt d1, QlBuiltins::BigInt d2, SemReason r1, SemReason r2 |
      boundFlowStepSsa(v, pos, mid, d1, upper, r1) and
      bounded(mid, b, d2, upper, fromBackEdge, origdelta, r2) and
      // upper = true:  v <= mid + d1 <= b + d1 + d2 = b + delta
      // upper = false: v >= mid + d1 >= b + d1 + d2 = b + delta
      delta = d1 + d2 and
      (if r1 instanceof SemNoReason then reason = r2 else reason = r1)
    )
    or
    exists(QlBuiltins::BigInt d, SemReason r1, SemReason r2 |
      boundedSsa(v, b, d, pos, upper, fromBackEdge, origdelta, r2)
      or
      boundedPhi(v, b, d, upper, fromBackEdge, origdelta, r2)
    |
      unequalIntegralSsa(v, b, d, pos, r1) and
      (
        upper = true and delta = d - 1.toBigInt()
        or
        upper = false and delta = d + 1.toBigInt()
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
    Sem::SsaVariable v, SemBound b, QlBuiltins::BigInt delta, SsaReadPosition pos, SemReason reason
  ) {
    exists(Sem::Expr e, QlBuiltins::BigInt d1, QlBuiltins::BigInt d2 |
      unequalFlowStepIntegralSsa(v, pos, e, d1, reason) and
      bounded(e, b, d2, true, _, _, _) and
      bounded(e, b, d2, false, _, _, _) and
      delta = d1 + d2
    )
  }

  /** Weakens a delta to lie in the range `[-1..1]`. */
  bindingset[delta, upper]
  private QlBuiltins::BigInt weakenDelta(boolean upper, QlBuiltins::BigInt delta) {
    delta = ([-1 .. 1]).toBigInt() and result = delta
    or
    upper = true and result = -1.toBigInt() and delta < -1.toBigInt()
    or
    upper = false and result = 1.toBigInt() and delta > 1.toBigInt()
  }

  /**
   * Holds if `b + delta` is a valid bound for `inp` when used as an input to
   * `phi` along `edge`.
   * - `upper = true`  : `inp <= b + delta`
   * - `upper = false` : `inp >= b + delta`
   */
  private predicate boundedPhiInp(
    Sem::SsaPhiNode phi, Sem::SsaVariable inp, SsaReadPositionPhiInputEdge edge, SemBound b,
    QlBuiltins::BigInt delta, boolean upper, boolean fromBackEdge, QlBuiltins::BigInt origdelta,
    SemReason reason
  ) {
    edge.phiInput(phi, inp) and
    exists(QlBuiltins::BigInt d, boolean fromBackEdge0 |
      boundedSsa(inp, b, d, edge, upper, fromBackEdge0, origdelta, reason)
      or
      boundedPhi(inp, b, d, upper, fromBackEdge0, origdelta, reason)
      or
      b.(SemSsaBound).getVariable() = inp and
      d = 0.toBigInt() and
      (upper = true or upper = false) and
      fromBackEdge0 = false and
      origdelta = 0.toBigInt() and
      reason = TSemNoReason()
    |
      if backEdge(phi, inp, edge)
      then
        fromBackEdge = true and
        (
          fromBackEdge0 = true and
          delta = weakenDelta(upper, d - origdelta) + origdelta
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
    SsaReadPositionPhiInputEdge edge, QlBuiltins::BigInt delta
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
    Sem::SsaPhiNode phi, Sem::SsaVariable inp, SsaReadPositionPhiInputEdge edge, boolean upper
  ) {
    exists(QlBuiltins::BigInt d, SemSsaBound phibound |
      phibound.getVariable() = phi and
      boundedPhiInp(phi, inp, edge, phibound, d, upper, _, _, _) and
      (
        upper = true and d <= 0.toBigInt()
        or
        upper = false and d >= 0.toBigInt()
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
    Sem::SsaPhiNode phi, boolean upper, SemBound b, QlBuiltins::BigInt delta, boolean fromBackEdge,
    QlBuiltins::BigInt origdelta, SemReason reason
  ) {
    boundedPhiInp(phi, _, _, b, delta, upper, fromBackEdge, origdelta, reason)
  }

  /**
   * Holds if the candidate bound `b + delta` for `phi` is valid for the phi input
   * `inp` along `edge`.
   */
  private predicate boundedPhiCandValidForEdge(
    Sem::SsaPhiNode phi, SemBound b, QlBuiltins::BigInt delta, boolean upper, boolean fromBackEdge,
    QlBuiltins::BigInt origdelta, SemReason reason, Sem::SsaVariable inp,
    SsaReadPositionPhiInputEdge edge
  ) {
    boundedPhiCand(phi, upper, b, delta, fromBackEdge, origdelta, reason) and
    (
      exists(QlBuiltins::BigInt d | boundedPhiInp1(phi, b, upper, inp, edge, d) |
        upper = true and d <= delta
      )
      or
      exists(QlBuiltins::BigInt d | boundedPhiInp1(phi, b, upper, inp, edge, d) |
        upper = false and d >= delta
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
    Sem::SsaPhiNode phi, SemBound b, QlBuiltins::BigInt delta, boolean upper, boolean fromBackEdge,
    QlBuiltins::BigInt origdelta, SemReason reason, int rix
  ) {
    exists(Sem::SsaVariable inp, SsaReadPositionPhiInputEdge edge |
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
    Sem::SsaPhiNode phi, SemBound b, QlBuiltins::BigInt delta, boolean upper, boolean fromBackEdge,
    QlBuiltins::BigInt origdelta, SemReason reason
  ) {
    exists(int r |
      maxPhiInputRank(phi, r) and
      boundedPhiRankStep(phi, b, delta, upper, fromBackEdge, origdelta, reason, r)
    )
  }

  private predicate includeBound(SemBound b) {
    // always include phi bounds
    b.(SemSsaBound).getVariable() instanceof Sem::SsaPhiNode
    or
    if b instanceof SemZeroBound then includeConstantBounds() else includeRelativeBounds()
  }

  /**
   * Holds if `e` has an intrinsic upper (for `upper = true`) or lower
   * (for `upper = false`) bound of `b + delta` as a base case for range analysis.
   */
  private predicate baseBound(Sem::Expr e, SemBound b, QlBuiltins::BigInt delta, boolean upper) {
    includeBound(b) and
    (
      e = b.getExpr(delta) and
      upper = [true, false]
      or
      hasConstantBound(e, delta, upper) and
      b instanceof SemZeroBound
      or
      upper = false and
      delta = 0.toBigInt() and
      semPositive(e.(Sem::BitAndExpr).getAnOperand()) and
      b instanceof SemZeroBound
    )
  }

  /**
   * Holds if the value being cast has an upper (for `upper = true`) or lower
   * (for `upper = false`) bound within the bounds of the resulting type.
   * For `upper = true` this means that the cast will not overflow and for
   * `upper = false` this means that the cast will not underflow.
   */
  private predicate safeNarrowingCast(NarrowingCastExpr cast, boolean upper) {
    exists(QlBuiltins::BigInt bound |
      bounded(cast.getOperand(), any(SemZeroBound zb), bound, upper, _, _, _)
    |
      upper = true and bound <= cast.getUpperBound().floor().toBigInt()
      or
      upper = false and bound >= cast.getLowerBound().(int).toBigInt()
    )
  }

  pragma[noinline]
  private predicate boundedCastExpr(
    NarrowingCastExpr cast, SemBound b, QlBuiltins::BigInt delta, boolean upper,
    boolean fromBackEdge, QlBuiltins::BigInt origdelta, SemReason reason
  ) {
    bounded(cast.getOperand(), b, delta, upper, fromBackEdge, origdelta, reason)
  }

  pragma[nomagic]
  private predicate initialBoundedUpper(Sem::Expr e) {
    exists(QlBuiltins::BigInt d |
      initialBounded(e, _, d, false, _, _, _) and
      d >= 0.toBigInt()
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
    exists(QlBuiltins::BigInt d |
      initialBounded(e, _, d, true, _, _, _) and
      d <= 0.toBigInt()
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
    Sem::Expr e, SemBound b, QlBuiltins::BigInt delta, boolean upper, boolean fromBackEdge,
    QlBuiltins::BigInt origdelta, SemReason reason
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
      Sem::getExprType(expr.(Sem::DivExpr)) instanceof Sem::FloatingPointType
    )
    or
    positively = true and
    expr instanceof Sem::PreIncExpr
  }

  /**
   * Holds if `e1 + delta` is a valid bound for `e2`.
   * - `upper = true`  : `e2 <= e1 + delta`
   * - `upper = false` : `e2 >= e1 + delta`
   *
   * This is restricted to simple forward-flowing steps and disregards phi-nodes.
   */
  private predicate preBoundStep(Sem::Expr e2, Sem::Expr e1, QlBuiltins::BigInt delta, boolean upper) {
    boundFlowStep(e2, e1, delta, upper)
    or
    exists(Sem::SsaVariable v, SsaReadPositionBlock bb |
      boundFlowStepSsa(v, bb, e1, delta, upper, _) and
      bb.getAnSsaRead(v) = e2
    )
  }

  /**
   * Holds if simple forward-flowing steps from `e` can reach an expression that
   * has multiple incoming bound-flow edges, that is, it has multiple ways to
   * get a valid bound.
   */
  private predicate reachesBoundMergepoint(Sem::Expr e, boolean upper) {
    2 <= strictcount(Sem::Expr mid | preBoundStep(e, mid, _, upper))
    or
    exists(Sem::SsaPhiNode v, SsaReadPositionBlock bb |
      boundFlowStepSsa(v, bb, _, _, upper, _) and
      bb.getAnSsaRead(v) = e
    )
    or
    exists(Sem::Expr e2 |
      preBoundStep(e2, e, _, upper) and
      reachesBoundMergepoint(e2, upper)
    )
  }

  pragma[nomagic]
  private predicate relevantPreBoundStep(
    Sem::Expr e2, Sem::Expr e1, QlBuiltins::BigInt delta, boolean upper
  ) {
    preBoundStep(e2, e1, delta, upper) and
    reachesBoundMergepoint(e2, upper)
  }

  /**
   * Holds if `b + delta` is a valid bound for `e` that can be found using only
   * simple forward-flowing steps and disregarding phi-nodes.
   * - `upper = true`  : `e <= b + delta`
   * - `upper = false` : `e >= b + delta`
   *
   * This predicate is used as a fast approximation for `bounded` to avoid
   * excessive computation in certain cases. In particular, this applies to
   * loop-unrolled code like
   * ```
   * if (..) x+=1; else x+=100;
   * x &= 7;
   * if (..) x+=1; else x+=100;
   * x &= 7;
   * if (..) x+=1; else x+=100;
   * x &= 7;
   * ...
   * ```
   */
  private predicate preBounded(Sem::Expr e, SemBound b, QlBuiltins::BigInt delta, boolean upper) {
    baseBound(e, b, delta, upper)
    or
    exists(Sem::Expr mid, QlBuiltins::BigInt d1, QlBuiltins::BigInt d2 |
      relevantPreBoundStep(e, mid, d1, upper) and
      preBounded(mid, b, d2, upper) and
      delta = d1 + d2
    )
  }

  private predicate bestPreBound(Sem::Expr e, SemBound b, QlBuiltins::BigInt delta, boolean upper) {
    delta = min(QlBuiltins::BigInt d | preBounded(e, b, d, upper) | d) and
    upper = true
    or
    delta = max(QlBuiltins::BigInt d | preBounded(e, b, d, upper) | d) and
    upper = false
  }

  /**
   * Holds if `b + delta` is a valid bound for `e`.
   * - `upper = true`  : `e <= b + delta`
   * - `upper = false` : `e >= b + delta`
   */
  predicate initialBounded(
    Sem::Expr e, SemBound b, QlBuiltins::BigInt delta, boolean upper, boolean fromBackEdge,
    QlBuiltins::BigInt origdelta, SemReason reason
  ) {
    not ignoreExprBound(e) and
    // ignore poor bounds
    not exists(QlBuiltins::BigInt d | bestPreBound(e, b, d, upper) |
      delta > d and upper = true
      or
      delta < d and upper = false
    ) and
    (
      baseBound(e, b, delta, upper) and
      fromBackEdge = false and
      origdelta = delta and
      reason = TSemNoReason()
      or
      exists(Sem::SsaVariable v, SsaReadPositionBlock bb |
        boundedSsa(v, b, delta, bb, upper, fromBackEdge, origdelta, reason) and
        bb.getAnSsaRead(v) = e
      )
      or
      exists(Sem::Expr mid, QlBuiltins::BigInt d1, QlBuiltins::BigInt d2 |
        boundFlowStep(e, mid, d1, upper) and
        bounded(mid, b, d2, upper, fromBackEdge, origdelta, reason) and
        // upper = true:  e <= mid + d1 <= b + d1 + d2 = b + delta
        // upper = false: e >= mid + d1 >= b + d1 + d2 = b + delta
        delta = d1 + d2
      )
      or
      exists(Sem::SsaPhiNode phi |
        boundedPhi(phi, b, delta, upper, fromBackEdge, origdelta, reason) and
        e = phi.getAUse()
      )
      or
      exists(Sem::Expr mid, QlBuiltins::BigInt factor, QlBuiltins::BigInt d |
        boundFlowStepMul(e, mid, factor) and
        bounded(mid, b, d, upper, fromBackEdge, origdelta, reason) and
        b instanceof SemZeroBound and
        delta = d * factor
      )
      or
      exists(Sem::Expr mid, QlBuiltins::BigInt factor, QlBuiltins::BigInt d |
        boundFlowStepDiv(e, mid, factor) and
        bounded(mid, b, d, upper, fromBackEdge, origdelta, reason) and
        b instanceof SemZeroBound and
        d >= 0.toBigInt() and
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
        Sem::ConditionalExpr cond, QlBuiltins::BigInt d1, QlBuiltins::BigInt d2, boolean fbe1,
        boolean fbe2, QlBuiltins::BigInt od1, QlBuiltins::BigInt od2, SemReason r1, SemReason r2
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
      or
      not javaCompatibility() and
      exists(Sem::Expr mid, QlBuiltins::BigInt d, QlBuiltins::BigInt f |
        e.(Sem::NegateExpr).getOperand() = mid and
        b instanceof SemZeroBound and
        bounded(mid, b, d, upper.booleanNot(), fromBackEdge, origdelta, reason) and
        f = -d and
        delta = f and
        if semPositive(e) then f >= 0.toBigInt() else any()
      )
      or
      exists(
        SemBound bLeft, SemBound bRight, QlBuiltins::BigInt dLeft, QlBuiltins::BigInt dRight,
        boolean fbeLeft, boolean fbeRight, QlBuiltins::BigInt odLeft, QlBuiltins::BigInt odRight,
        SemReason rLeft, SemReason rRight
      |
        boundedAddOperand(e, upper, bLeft, false, dLeft, fbeLeft, odLeft, rLeft) and
        boundedAddOperand(e, upper, bRight, true, dRight, fbeRight, odRight, rRight) and
        delta = dLeft + dRight and
        fromBackEdge = fbeLeft.booleanOr(fbeRight)
      |
        b = bLeft and origdelta = odLeft and reason = rLeft and bRight instanceof SemZeroBound
        or
        b = bRight and origdelta = odRight and reason = rRight and bLeft instanceof SemZeroBound
      )
      or
      not javaCompatibility() and
      exists(
        QlBuiltins::BigInt dLeft, QlBuiltins::BigInt dRight, boolean fbeLeft, boolean fbeRight
      |
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
        delta = dLeft - dRight and
        fromBackEdge = fbeLeft.booleanOr(fbeRight)
      )
      or
      not javaCompatibility() and
      exists(
        Sem::RemExpr rem, QlBuiltins::BigInt d_max, QlBuiltins::BigInt d1, QlBuiltins::BigInt d2,
        boolean fbe1, boolean fbe2, QlBuiltins::BigInt od1, QlBuiltins::BigInt od2, SemReason r1,
        SemReason r2
      |
        rem = e and
        b instanceof SemZeroBound and
        not (upper = true and semPositive(rem.getRightOperand())) and
        not (upper = true and semPositive(rem.getLeftOperand())) and
        boundedRemExpr(rem, true, d1, fbe1, od1, r1) and
        boundedRemExpr(rem, false, d2, fbe2, od2, r2) and
        (
          if (d1).abs() > (d2).abs()
          then (
            d_max = d1 and fromBackEdge = fbe1 and origdelta = od1 and reason = r1
          ) else (
            d_max = d2 and fromBackEdge = fbe2 and origdelta = od2 and reason = r2
          )
        )
      |
        upper = true and delta = d_max.abs() - 1.toBigInt()
        or
        upper = false and delta = -d_max.abs() + 1.toBigInt()
      )
      or
      not javaCompatibility() and
      exists(
        QlBuiltins::BigInt dLeft, QlBuiltins::BigInt dRight, boolean fbeLeft, boolean fbeRight,
        QlBuiltins::BigInt odLeft, QlBuiltins::BigInt odRight, SemReason rLeft, SemReason rRight
      |
        boundedMulOperand(e, upper, true, dLeft, fbeLeft, odLeft, rLeft) and
        boundedMulOperand(e, upper, false, dRight, fbeRight, odRight, rRight) and
        delta = ((dLeft) * (dRight)) and
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
    Sem::ConditionalExpr cond, SemBound b, boolean upper, boolean branch, QlBuiltins::BigInt delta,
    boolean fromBackEdge, QlBuiltins::BigInt origdelta, SemReason reason
  ) {
    bounded(cond.getBranchExpr(branch), b, delta, upper, fromBackEdge, origdelta, reason)
  }

  pragma[nomagic]
  private predicate boundedAddOperand(
    Sem::AddExpr add, boolean upper, SemBound b, boolean isLeft, QlBuiltins::BigInt delta,
    boolean fromBackEdge, QlBuiltins::BigInt origdelta, SemReason reason
  ) {
    // `valueFlowStep` already handles the case where one of the operands is a constant.
    not valueFlowStep(add, _, _) and
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
    Sem::SubExpr sub, boolean upper, SemBound b, QlBuiltins::BigInt delta, boolean fromBackEdge,
    QlBuiltins::BigInt origdelta, SemReason reason
  ) {
    // `valueFlowStep` already handles the case where one of the operands is a constant.
    not valueFlowStep(sub, _, _) and
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
    Sem::SubExpr sub, boolean upper, QlBuiltins::BigInt delta, boolean fromBackEdge
  ) {
    // `valueFlowStep` already handles the case where one of the operands is a constant.
    not valueFlowStep(sub, _, _) and
    bounded(sub.getRightOperand(), any(SemZeroBound zb), delta, upper.booleanNot(), fromBackEdge, _,
      _)
  }

  pragma[nomagic]
  private predicate boundedRemExpr(
    Sem::RemExpr rem, boolean upper, QlBuiltins::BigInt delta, boolean fromBackEdge,
    QlBuiltins::BigInt origdelta, SemReason reason
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
    Sem::MulExpr mul, boolean upper, boolean isLeft, QlBuiltins::BigInt delta, boolean fromBackEdge,
    QlBuiltins::BigInt origdelta, SemReason reason
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
