/**
 * Provides classes and predicates for range analysis.
 *
 * An inferred bound can either be a specific integer or a `ValueNumber`
 * representing the abstract value of a set of `Instruction`s.
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
 * In its simplest form the step relation `I1 --> I2` relates two `Instruction`s
 * such that `I1 <= B` implies `I2 <= B` for any `B` (with a second separate
 * step relation handling lower bounds). Examples of such steps include
 * assignments `I2 = I1` and conditions `x <= I1` where `I2` is a use of `x`
 * guarded by the condition.
 *
 * In order to handle subtractions and additions with constants, and strict
 * comparisons, the step relation is augmented with an integer delta. With this
 * generalization `I1 --(delta)--> I2` relates two `Instruction`s and an integer
 * such that `I1 <= B` implies `I2 <= B + delta` for any `B`. This corresponds
 * to the predicate `boundFlowStep`.
 *
 * The complete range analysis is then implemented as the transitive closure of
 * the step relation summing the deltas along the way. If `I1` transitively
 * steps to `I2`, `delta` is the sum of deltas along the path, and `B` is an
 * interesting bound equal to the value of `I1` then `I2 <= B + delta`. This
 * corresponds to the predicate `boundedInstruction`.
 *
 * Bounds come in two forms: either they are relative to zero (and thus provide
 * a constant bound), or they are relative to some program value. This value is
 * represented by the `ValueNumber` class, each instance of which represents a
 * set of `Instructions` that must have the same value.
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

import cpp
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.controlflow.IRGuards
private import semmle.code.cpp.ir.ValueNumbering
private import RangeUtils
private import SignAnalysis
import Bound

cached
private module RangeAnalysisCache {
  cached
  module RangeAnalysisPublic {
    /**
     * Holds if `b + delta` is a valid bound for `i` and this is the best such delta.
     * - `upper = true`  : `i <= b + delta`
     * - `upper = false` : `i >= b + delta`
     *
     * The reason for the bound is given by `reason` and may be either a condition
     * or `NoReason` if the bound was proven directly without the use of a bounding
     * condition.
     */
    cached
    predicate boundedInstruction(Instruction i, Bound b, int delta, boolean upper, Reason reason) {
      boundedInstruction(i, b, delta, upper, _, _, reason) and
      bestInstructionBound(i, b, delta, upper)
    }

    /**
     * Holds if `b + delta` is a valid bound for `op` and this is the best such delta.
     * - `upper = true`  : `op <= b + delta`
     * - `upper = false` : `op >= b + delta`
     *
     * The reason for the bound is given by `reason` and may be either a condition
     * or `NoReason` if the bound was proven directly without the use of a bounding
     * condition.
     */
    cached
    predicate boundedOperand(Operand op, Bound b, int delta, boolean upper, Reason reason) {
      boundedOperandCand(op, b, delta, upper, reason) and
      bestOperandBound(op, b, delta, upper)
    }
  }

  /**
   * Holds if `guard = boundFlowCond(_, _, _, _, _) or guard = eqFlowCond(_, _, _, _, _)`.
   */
  cached
  predicate possibleReason(IRGuardCondition guard) {
    guard = boundFlowCond(_, _, _, _, _)
    or
    guard = eqFlowCond(_, _, _, _, _)
  }
}

private import RangeAnalysisCache
import RangeAnalysisPublic

/**
 * Holds if `b + delta` is a valid bound for `e` and this is the best such delta.
 * - `upper = true`  : `e <= b + delta`
 * - `upper = false` : `e >= b + delta`
 */
private predicate bestInstructionBound(Instruction i, Bound b, int delta, boolean upper) {
  delta = min(int d | boundedInstruction(i, b, d, upper, _, _, _)) and upper = true
  or
  delta = max(int d | boundedInstruction(i, b, d, upper, _, _, _)) and upper = false
}

/**
 * Holds if `b + delta` is a valid bound for `op`.
 * - `upper = true`  : `op <= b + delta`
 * - `upper = false` : `op >= b + delta`
 *
 * The reason for the bound is given by `reason` and may be either a condition
 * or `NoReason` if the bound was proven directly without the use of a bounding
 * condition.
 */
private predicate boundedOperandCand(Operand op, Bound b, int delta, boolean upper, Reason reason) {
  boundedNonPhiOperand(op, b, delta, upper, _, _, reason)
  or
  boundedPhiOperand(op, b, delta, upper, _, _, reason)
}

/**
 * Holds if `b + delta` is a valid bound for `op` and this is the best such delta.
 * - `upper = true`  : `op <= b + delta`
 * - `upper = false` : `op >= b + delta`
 */
private predicate bestOperandBound(Operand op, Bound b, int delta, boolean upper) {
  delta = min(int d | boundedOperandCand(op, b, d, upper, _)) and upper = true
  or
  delta = max(int d | boundedOperandCand(op, b, d, upper, _)) and upper = false
}

/**
 * Gets a condition that tests whether `vn` equals `bound + delta`.
 *
 * If the condition evaluates to `testIsTrue`:
 * - `isEq = true`  : `vn == bound + delta`
 * - `isEq = false` : `vn != bound + delta`
 */
private IRGuardCondition eqFlowCond(
  ValueNumber vn, Operand bound, int delta, boolean isEq, boolean testIsTrue
) {
  result.comparesEq(vn.getAUse(), bound, delta, isEq, testIsTrue)
}

/**
 * Holds if `op1 + delta` is a valid bound for `op2`.
 * - `upper = true`  : `op2 <= op1 + delta`
 * - `upper = false` : `op2 >= op1 + delta`
 */
private predicate boundFlowStepSsa(
  NonPhiOperand op2, Operand op1, int delta, boolean upper, Reason reason
) {
  exists(IRGuardCondition guard, boolean testIsTrue |
    guard = boundFlowCond(valueNumberOfOperand(op2), op1, delta, upper, testIsTrue) and
    guard.controls(op2.getUse().getBlock(), testIsTrue) and
    reason = TCondReason(guard)
  )
  or
  exists(IRGuardCondition guard, boolean testIsTrue, SafeCastInstruction cast |
    valueNumberOfOperand(op2) = valueNumber(cast.getUnary()) and
    guard = boundFlowCond(valueNumber(cast), op1, delta, upper, testIsTrue) and
    guard.controls(op2.getUse().getBlock(), testIsTrue) and
    reason = TCondReason(guard)
  )
}

/**
 * Gets a condition that tests whether `vn` is bounded by `bound + delta`.
 *
 * If the condition evaluates to `testIsTrue`:
 * - `upper = true`  : `vn <= bound + delta`
 * - `upper = false` : `vn >= bound + delta`
 */
private IRGuardCondition boundFlowCond(
  ValueNumber vn, NonPhiOperand bound, int delta, boolean upper, boolean testIsTrue
) {
  exists(int d |
    result.comparesLt(vn.getAUse(), bound, d, upper, testIsTrue) and
    // `comparesLt` provides bounds of the form `x < y + k` or `x >= y + k`, but we need
    // `x <= y + k` so we strengthen here. `testIsTrue` has the same semantics in `comparesLt` as
    // it does here, so we don't need to account for it.
    if upper = true then delta = d - 1 else delta = d
  )
  or
  result = eqFlowCond(vn, bound, delta, true, testIsTrue) and
  (upper = true or upper = false)
}

private newtype TReason =
  TNoReason() or
  TCondReason(IRGuardCondition guard) { possibleReason(guard) }

/**
 * A reason for an inferred bound. This can either be `CondReason` if the bound
 * is due to a specific condition, or `NoReason` if the bound is inferred
 * without going through a bounding condition.
 */
abstract class Reason extends TReason {
  abstract string toString();
}

class NoReason extends Reason, TNoReason {
  override string toString() { result = "NoReason" }
}

class CondReason extends Reason, TCondReason {
  IRGuardCondition getCond() { this = TCondReason(result) }

  override string toString() { result = getCond().toString() }
}

/**
 * Holds if `typ` is a small integral type with the given lower and upper bounds.
 */
private predicate typeBound(IRIntegerType typ, int lowerbound, int upperbound) {
  typ.isSigned() and typ.getByteSize() = 1 and lowerbound = -128 and upperbound = 127
  or
  typ.isUnsigned() and typ.getByteSize() = 1 and lowerbound = 0 and upperbound = 255
  or
  typ.isSigned() and typ.getByteSize() = 2 and lowerbound = -32768 and upperbound = 32767
  or
  typ.isUnsigned() and typ.getByteSize() = 2 and lowerbound = 0 and upperbound = 65535
}

/**
 * A cast to a small integral type that may overflow or underflow.
 */
private class NarrowingCastInstruction extends ConvertInstruction {
  NarrowingCastInstruction() {
    not this instanceof SafeCastInstruction and
    typeBound(getResultIRType(), _, _)
  }

  /** Gets the lower bound of the resulting type. */
  int getLowerBound() { typeBound(getResultIRType(), result, _) }

  /** Gets the upper bound of the resulting type. */
  int getUpperBound() { typeBound(getResultIRType(), _, result) }
}

/**
 * Holds if `op + delta` is a valid bound for `i`.
 * - `upper = true`  : `i <= op + delta`
 * - `upper = false` : `i >= op + delta`
 */
private predicate boundFlowStep(Instruction i, NonPhiOperand op, int delta, boolean upper) {
  valueFlowStep(i, op, delta) and
  (upper = true or upper = false)
  or
  i.(SafeCastInstruction).getAnOperand() = op and
  delta = 0 and
  (upper = true or upper = false)
  or
  exists(Operand x |
    i.(AddInstruction).getAnOperand() = op and
    i.(AddInstruction).getAnOperand() = x and
    op != x
  |
    not exists(getValue(getConstantValue(op.getUse()))) and
    not exists(getValue(getConstantValue(x.getUse()))) and
    if strictlyPositive(x)
    then upper = false and delta = 1
    else
      if positive(x)
      then upper = false and delta = 0
      else
        if strictlyNegative(x)
        then upper = true and delta = -1
        else
          if negative(x)
          then upper = true and delta = 0
          else none()
  )
  or
  exists(Operand x |
    exists(SubInstruction sub |
      i = sub and
      sub.getLeftOperand() = op and
      sub.getRightOperand() = x
    )
  |
    // `x` with constant value is covered by valueFlowStep
    not exists(getValue(getConstantValue(x.getUse()))) and
    if strictlyPositive(x)
    then upper = true and delta = -1
    else
      if positive(x)
      then upper = true and delta = 0
      else
        if strictlyNegative(x)
        then upper = false and delta = 1
        else
          if negative(x)
          then upper = false and delta = 0
          else none()
  )
  or
  i.(RemInstruction).getRightOperand() = op and positive(op) and delta = -1 and upper = true
  or
  i.(RemInstruction).getLeftOperand() = op and positive(op) and delta = 0 and upper = true
  or
  i.(BitAndInstruction).getAnOperand() = op and positive(op) and delta = 0 and upper = true
  or
  i.(BitOrInstruction).getAnOperand() = op and
  positiveInstruction(i) and
  delta = 0 and
  upper = false
  // TODO: min, max, rand
}

private predicate boundFlowStepMul(Instruction i1, Operand op, int factor) {
  exists(Instruction c, int k | k = getValue(getConstantValue(c)) and k > 0 |
    i1.(MulInstruction).hasOperands(op, c.getAUse()) and factor = k
    or
    exists(ShiftLeftInstruction i |
      i = i1 and i.getLeftOperand() = op and i.getRightOperand() = c.getAUse() and factor = 2.pow(k)
    )
  )
}

private predicate boundFlowStepDiv(Instruction i1, Operand op, int factor) {
  exists(Instruction c, int k | k = getValue(getConstantValue(c)) and k > 0 |
    exists(DivInstruction i |
      i = i1 and i.getLeftOperand() = op and i.getRight() = c and factor = k
    )
    or
    exists(ShiftRightInstruction i |
      i = i1 and i.getLeftOperand() = op and i.getRight() = c and factor = 2.pow(k)
    )
  )
}

/**
 * Holds if `b` is a valid bound for `op`
 */
pragma[noinline]
private predicate boundedNonPhiOperand(
  NonPhiOperand op, Bound b, int delta, boolean upper, boolean fromBackEdge, int origdelta,
  Reason reason
) {
  exists(NonPhiOperand op2, int d1, int d2 |
    boundFlowStepSsa(op, op2, d1, upper, reason) and
    boundedNonPhiOperand(op2, b, d2, upper, fromBackEdge, origdelta, _) and
    delta = d1 + d2
  )
  or
  boundedInstruction(op.getDef(), b, delta, upper, fromBackEdge, origdelta, reason)
  or
  exists(int d, Reason r1, Reason r2 |
    boundedNonPhiOperand(op, b, d, upper, fromBackEdge, origdelta, r2)
  |
    unequalOperand(op, b, d, r1) and
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
 * Holds if `op1 + delta` is a valid bound for `op2`.
 * - `upper = true`  : `op2 <= op1 + delta`
 * - `upper = false` : `op2 >= op1 + delta`
 */
private predicate boundFlowStepPhi(
  PhiInputOperand op2, Operand op1, int delta, boolean upper, Reason reason
) {
  op2.getDef().(CopyInstruction).getSourceValueOperand() = op1 and
  (upper = true or upper = false) and
  reason = TNoReason() and
  delta = 0
  or
  exists(IRGuardCondition guard, boolean testIsTrue |
    guard = boundFlowCond(valueNumberOfOperand(op2), op1, delta, upper, testIsTrue) and
    guard.controlsEdge(op2.getPredecessorBlock(), op2.getUse().getBlock(), testIsTrue) and
    reason = TCondReason(guard)
  )
}

private predicate boundedPhiOperand(
  PhiInputOperand op, Bound b, int delta, boolean upper, boolean fromBackEdge, int origdelta,
  Reason reason
) {
  exists(NonPhiOperand op2, int d1, int d2, Reason r1, Reason r2 |
    boundFlowStepPhi(op, op2, d1, upper, r1) and
    boundedNonPhiOperand(op2, b, d2, upper, fromBackEdge, origdelta, r2) and
    delta = d1 + d2 and
    (if r1 instanceof NoReason then reason = r2 else reason = r1)
  )
  or
  boundedInstruction(op.getDef(), b, delta, upper, fromBackEdge, origdelta, reason)
  or
  exists(int d, Reason r1, Reason r2 |
    boundedInstruction(op.getDef(), b, d, upper, fromBackEdge, origdelta, r2)
  |
    unequalOperand(op, b, d, r1) and
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

/** Holds if `op2 != op1 + delta` at `pos`. */
private predicate unequalFlowStep(Operand op2, Operand op1, int delta, Reason reason) {
  exists(IRGuardCondition guard, boolean testIsTrue |
    guard = eqFlowCond(valueNumberOfOperand(op2), op1, delta, false, testIsTrue) and
    guard.controls(op2.getUse().getBlock(), testIsTrue) and
    reason = TCondReason(guard)
  )
}

/**
 * Holds if `op != b + delta` at `pos`.
 */
private predicate unequalOperand(Operand op, Bound b, int delta, Reason reason) {
  exists(Operand op2, int d1, int d2 |
    unequalFlowStep(op, op2, d1, reason) and
    boundedNonPhiOperand(op2, b, d2, true, _, _, _) and
    boundedNonPhiOperand(op2, b, d2, false, _, _, _) and
    delta = d1 + d2
  )
}

private predicate boundedPhiCandValidForEdge(
  PhiInstruction phi, Bound b, int delta, boolean upper, boolean fromBackEdge, int origdelta,
  Reason reason, PhiInputOperand op
) {
  boundedPhiCand(phi, upper, b, delta, fromBackEdge, origdelta, reason) and
  (
    exists(int d | boundedPhiInp1(phi, op, b, d, upper) | upper = true and d <= delta)
    or
    exists(int d | boundedPhiInp1(phi, op, b, d, upper) | upper = false and d >= delta)
    or
    selfBoundedPhiInp(phi, op, upper)
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

private predicate boundedPhiInp(
  PhiInstruction phi, PhiInputOperand op, Bound b, int delta, boolean upper, boolean fromBackEdge,
  int origdelta, Reason reason
) {
  phi.getAnOperand() = op and
  exists(int d, boolean fromBackEdge0 |
    boundedPhiOperand(op, b, d, upper, fromBackEdge0, origdelta, reason)
    or
    b.(ValueNumberBound).getInstruction() = op.getDef() and
    d = 0 and
    (upper = true or upper = false) and
    fromBackEdge0 = false and
    origdelta = 0 and
    reason = TNoReason()
  |
    if backEdge(phi, op)
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

pragma[noinline]
private predicate boundedPhiInp1(
  PhiInstruction phi, PhiInputOperand op, Bound b, int delta, boolean upper
) {
  boundedPhiInp(phi, op, b, delta, upper, _, _, _)
}

private predicate selfBoundedPhiInp(PhiInstruction phi, PhiInputOperand op, boolean upper) {
  exists(int d, ValueNumberBound phibound |
    phibound.getInstruction() = phi and
    boundedPhiInp(phi, op, phibound, d, upper, _, _, _) and
    (
      upper = true and d <= 0
      or
      upper = false and d >= 0
    )
  )
}

pragma[noinline]
private predicate boundedPhiCand(
  PhiInstruction phi, boolean upper, Bound b, int delta, boolean fromBackEdge, int origdelta,
  Reason reason
) {
  exists(PhiInputOperand op |
    boundedPhiInp(phi, op, b, delta, upper, fromBackEdge, origdelta, reason)
  )
}

/**
 * Holds if the value being cast has an upper (for `upper = true`) or lower
 * (for `upper = false`) bound within the bounds of the resulting type.
 * For `upper = true` this means that the cast will not overflow and for
 * `upper = false` this means that the cast will not underflow.
 */
private predicate safeNarrowingCast(NarrowingCastInstruction cast, boolean upper) {
  exists(int bound |
    boundedNonPhiOperand(cast.getAnOperand(), any(ZeroBound zb), bound, upper, _, _, _)
  |
    upper = true and bound <= cast.getUpperBound()
    or
    upper = false and bound >= cast.getLowerBound()
  )
}

pragma[noinline]
private predicate boundedCastExpr(
  NarrowingCastInstruction cast, Bound b, int delta, boolean upper, boolean fromBackEdge,
  int origdelta, Reason reason
) {
  boundedNonPhiOperand(cast.getAnOperand(), b, delta, upper, fromBackEdge, origdelta, reason)
}

/**
 * Holds if `b + delta` is a valid bound for `i`.
 * - `upper = true`  : `i <= b + delta`
 * - `upper = false` : `i >= b + delta`
 */
private predicate boundedInstruction(
  Instruction i, Bound b, int delta, boolean upper, boolean fromBackEdge, int origdelta,
  Reason reason
) {
  i instanceof PhiInstruction and
  forex(PhiInputOperand op | op = i.getAnOperand() |
    boundedPhiCandValidForEdge(i, b, delta, upper, fromBackEdge, origdelta, reason, op)
  )
  or
  i = b.getInstruction(delta) and
  (upper = true or upper = false) and
  fromBackEdge = false and
  origdelta = delta and
  reason = TNoReason()
  or
  exists(Operand mid, int d1, int d2 |
    boundFlowStep(i, mid, d1, upper) and
    boundedNonPhiOperand(mid, b, d2, upper, fromBackEdge, origdelta, reason) and
    delta = d1 + d2 and
    not exists(getValue(getConstantValue(i)))
  )
  or
  exists(Operand mid, int factor, int d |
    boundFlowStepMul(i, mid, factor) and
    boundedNonPhiOperand(mid, b, d, upper, fromBackEdge, origdelta, reason) and
    b instanceof ZeroBound and
    delta = d * factor and
    not exists(getValue(getConstantValue(i)))
  )
  or
  exists(Operand mid, int factor, int d |
    boundFlowStepDiv(i, mid, factor) and
    boundedNonPhiOperand(mid, b, d, upper, fromBackEdge, origdelta, reason) and
    d >= 0 and
    b instanceof ZeroBound and
    delta = d / factor and
    not exists(getValue(getConstantValue(i)))
  )
  or
  exists(NarrowingCastInstruction cast |
    cast = i and
    safeNarrowingCast(cast, upper.booleanNot()) and
    boundedCastExpr(cast, b, delta, upper, fromBackEdge, origdelta, reason)
  )
}
