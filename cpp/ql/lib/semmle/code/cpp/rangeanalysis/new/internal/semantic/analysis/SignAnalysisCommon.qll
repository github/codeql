/**
 * Provides sign analysis to determine whether expression are always positive
 * or negative.
 *
 * The analysis is implemented as an abstract interpretation over the
 * three-valued domain `{negative, zero, positive}`.
 */

private import codeql.rangeanalysis.RangeAnalysis
private import RangeAnalysisImpl
private import SignAnalysisSpecific as Specific
private import semmle.code.cpp.rangeanalysis.new.internal.semantic.Semantic
private import semmle.code.cpp.rangeanalysis.new.internal.semantic.SemanticLocation
private import ConstantAnalysis
private import Sign

module SignAnalysis<DeltaSig D> {
  private import codeql.rangeanalysis.internal.RangeUtils::MakeUtils<SemLocation, Sem, D>

  /**
   * An SSA definition for which the analysis can compute the sign.
   *
   * The actual computation of the sign is done in an override of the `getSign()` predicate. The
   * charpred of any subclass must _not_ invoke `getSign()`, directly or indirectly. This ensures
   * that the charpred does not introduce negative recursion. The `getSign()` predicate may be
   * recursive.
   */
  abstract private class SignDef instanceof SemSsaVariable {
    final string toString() { result = super.toString() }

    /** Gets the possible signs of this SSA definition. */
    abstract Sign getSign();
  }

  /** An SSA definition whose sign is computed based on standard flow. */
  abstract private class FlowSignDef extends SignDef {
    abstract override Sign getSign();
  }

  /** An SSA definition whose sign is determined by the sign of that definitions source expression. */
  private class ExplicitSignDef extends FlowSignDef instanceof SemSsaExplicitUpdate {
    final override Sign getSign() { result = semExprSign(super.getDefiningExpr()) }
  }

  /** An SSA Phi definition, whose sign is the union of the signs of its inputs. */
  private class PhiSignDef extends FlowSignDef instanceof SemSsaPhiNode {
    final override Sign getSign() {
      exists(SemSsaVariable inp, SsaReadPositionPhiInputEdge edge |
        edge.phiInput(this, inp) and
        result = semSsaSign(inp, edge)
      )
    }
  }

  /** An SSA definition whose sign is computed by a language-specific implementation. */
  abstract class CustomSignDef extends SignDef {
    abstract override Sign getSign();
  }

  /**
   * An expression for which the analysis can compute the sign.
   *
   * The actual computation of the sign is done in an override of the `getSign()` predicate. The
   * charpred of any subclass must _not_ invoke `getSign()`, directly or indirectly. This ensures
   * that the charpred does not introduce negative recursion. The `getSign()` predicate may be
   * recursive.
   *
   * Concrete implementations extend one of the following subclasses:
   * - `ConstantSignExpr`, for expressions with a compile-time constant value.
   * - `FlowSignExpr`, for expressions whose sign can be computed from the signs of their operands.
   * - `CustomsignExpr`, for expressions whose sign can be computed by a language-specific
   *   implementation.
   *
   * If the same expression matches more than one of the above subclasses, the sign is computed as
   * follows:
   * - The sign of a `ConstantSignExpr` is computed solely from `ConstantSignExpr.getSign()`,
   *   regardless of any other subclasses.
   * - If a non-`ConstantSignExpr` expression matches exactly one of `FlowSignExpr` or
   *   `CustomSignExpr`, the sign is computed by that class' `getSign()` predicate.
   * - If a non-`ConstantSignExpr` expression matches both `FlowSignExpr` and `CustomSignExpr`, the
   *   sign is the _intersection_ of the signs of those two classes' `getSign()` predicates. Thus,
   *   both classes have the opportunity to _restrict_ the set of possible signs, not to generate new
   *   possible signs.
   * - If an expression does not match any of the three subclasses, then it can have any sign.
   *
   * Note that the `getSign()` predicate is introduced only in subclasses of `SignExpr`.
   */
  abstract class SignExpr instanceof SemExpr {
    SignExpr() { not Specific::ignoreExprSign(this) }

    final string toString() { result = super.toString() }

    abstract Sign getSign();
  }

  /** An expression whose sign is determined by its constant numeric value. */
  private class ConstantSignExpr extends SignExpr {
    ConstantSignExpr() {
      this instanceof SemConstantIntegerExpr or
      exists(this.(SemNumericLiteralExpr).getApproximateFloatValue())
    }

    final override Sign getSign() {
      exists(int i | this.(SemConstantIntegerExpr).getIntValue() = i |
        i < 0 and result = TNeg()
        or
        i = 0 and result = TZero()
        or
        i > 0 and result = TPos()
      )
      or
      not exists(this.(SemConstantIntegerExpr).getIntValue()) and
      exists(float f | f = this.(SemNumericLiteralExpr).getApproximateFloatValue() |
        f < 0 and result = TNeg()
        or
        f = 0 and result = TZero()
        or
        f > 0 and result = TPos()
      )
    }
  }

  abstract private class NonConstantSignExpr extends SignExpr {
    NonConstantSignExpr() { not this instanceof ConstantSignExpr }

    final override Sign getSign() {
      // The result is the _intersection_ of the signs computed from flow and by the language.
      (result = this.(FlowSignExpr).getSignRestriction() or not this instanceof FlowSignExpr) and
      (result = this.(CustomSignExpr).getSignRestriction() or not this instanceof CustomSignExpr)
    }
  }

  /** An expression whose sign is computed from the signs of its operands. */
  abstract private class FlowSignExpr extends NonConstantSignExpr {
    abstract Sign getSignRestriction();
  }

  /** An expression whose sign is computed by a language-specific implementation. */
  abstract class CustomSignExpr extends NonConstantSignExpr {
    abstract Sign getSignRestriction();
  }

  /** An expression whose sign is unknown. */
  private class UnknownSignExpr extends SignExpr {
    UnknownSignExpr() {
      not this instanceof FlowSignExpr and
      not this instanceof CustomSignExpr and
      not this instanceof ConstantSignExpr and
      (
        // Only track numeric types.
        Sem::getExprType(this) instanceof SemNumericType
        or
        // Unless the language says to track this expression anyway.
        Specific::trackUnknownNonNumericExpr(this)
      )
    }

    final override Sign getSign() { semAnySign(result) }
  }

  /**
   * A `Load` expression whose sign is computed from the sign of its SSA definition, restricted by
   * inference from any intervening guards.
   */
  class UseSignExpr extends FlowSignExpr {
    SemSsaVariable v;

    UseSignExpr() { v.getAUse() = this }

    override Sign getSignRestriction() {
      // Propagate via SSA
      // Propagate the sign from the def of `v`, incorporating any inference from guards.
      result = semSsaSign(v, any(SsaReadPositionBlock bb | bb.getBlock().getAnExpr() = this))
      or
      // No block for this read. Just use the sign of the def.
      // REVIEW: How can this happen?
      not exists(SsaReadPositionBlock bb | bb.getBlock().getAnExpr() = this) and
      result = semSsaDefSign(v)
    }
  }

  /** A binary expression whose sign is computed from the signs of its operands. */
  private class BinarySignExpr extends FlowSignExpr {
    SemBinaryExpr binary;

    BinarySignExpr() { binary = this }

    override Sign getSignRestriction() {
      exists(SemExpr left, SemExpr right |
        binaryExprOperands(binary, left, right) and
        result =
          semExprSign(pragma[only_bind_out](left))
              .applyBinaryOp(semExprSign(pragma[only_bind_out](right)), binary.getOpcode())
      )
      or
      exists(SemDivExpr div | div = binary |
        result = semExprSign(div.getLeftOperand()) and
        result != TZero() and
        div.getRightOperand().(SemFloatingPointLiteralExpr).getFloatValue() = 0
      )
    }
  }

  /** An expression of an unsigned type. */
  private class UnsignedExpr extends FlowSignExpr {
    UnsignedExpr() { Sem::getExprType(this) instanceof SemUnsignedIntegerType }

    override Sign getSignRestriction() {
      result = TPos() or
      result = TZero()
    }
  }

  pragma[nomagic]
  private predicate binaryExprOperands(SemBinaryExpr binary, SemExpr left, SemExpr right) {
    binary.getLeftOperand() = left and binary.getRightOperand() = right
  }

  /**
   * A `Convert`, `Box`, or `Unbox` expression.
   */
  private class SemCastExpr instanceof SemUnaryExpr {
    string toString() { result = super.toString() }

    SemCastExpr() {
      this instanceof SemConvertExpr
      or
      this instanceof SemBoxExpr
      or
      this instanceof SemUnboxExpr
    }
  }

  /** A unary expression whose sign is computed from the sign of its operand. */
  private class UnarySignExpr extends FlowSignExpr {
    SemUnaryExpr unary;

    UnarySignExpr() { unary = this and not this instanceof SemCastExpr }

    override Sign getSignRestriction() {
      result =
        semExprSign(pragma[only_bind_out](unary.getOperand())).applyUnaryOp(unary.getOpcode())
    }
  }

  /**
   * A `Convert`, `Box`, or `Unbox` expression, whose sign is computed based on
   * the sign of its operand and the source and destination types.
   */
  abstract private class CastSignExpr extends FlowSignExpr {
    SemUnaryExpr cast;

    CastSignExpr() { cast = this and cast instanceof SemCastExpr }

    override Sign getSignRestriction() { result = semExprSign(cast.getOperand()) }
  }

  /**
   * A `Convert` expression.
   */
  private class ConvertSignExpr extends CastSignExpr {
    override SemConvertExpr cast;
  }

  /**
   * A `Box` expression.
   */
  private class BoxSignExpr extends CastSignExpr {
    override SemBoxExpr cast;
  }

  /**
   * An `Unbox` expression.
   */
  private class UnboxSignExpr extends CastSignExpr {
    override SemUnboxExpr cast;

    UnboxSignExpr() {
      exists(SemType fromType | fromType = Sem::getExprType(cast.getOperand()) |
        // Only numeric source types are handled here.
        fromType instanceof SemNumericType
      )
    }
  }

  private predicate unknownSign(SemExpr e) { e instanceof UnknownSignExpr }

  /**
   * Holds if `lowerbound` is a lower bound for `v` at `pos`. This is restricted
   * to only include bounds for which we might determine a sign.
   */
  private predicate lowerBound(
    SemExpr lowerbound, SemSsaVariable v, SsaReadPosition pos, boolean isStrict
  ) {
    exists(boolean testIsTrue, SemRelationalExpr comp |
      pos.hasReadOfVar(v) and
      guardControlsSsaRead(semGetComparisonGuard(comp), pos, testIsTrue) and
      not unknownSign(lowerbound)
    |
      testIsTrue = true and
      comp.getLesserOperand() = lowerbound and
      comp.getGreaterOperand() = ssaRead(v, D::fromInt(0)) and
      (if comp.isStrict() then isStrict = true else isStrict = false)
      or
      testIsTrue = false and
      comp.getGreaterOperand() = lowerbound and
      comp.getLesserOperand() = ssaRead(v, D::fromInt(0)) and
      (if comp.isStrict() then isStrict = false else isStrict = true)
    )
  }

  /**
   * Holds if `upperbound` is an upper bound for `v` at `pos`. This is restricted
   * to only include bounds for which we might determine a sign.
   */
  private predicate upperBound(
    SemExpr upperbound, SemSsaVariable v, SsaReadPosition pos, boolean isStrict
  ) {
    exists(boolean testIsTrue, SemRelationalExpr comp |
      pos.hasReadOfVar(v) and
      guardControlsSsaRead(semGetComparisonGuard(comp), pos, testIsTrue) and
      not unknownSign(upperbound)
    |
      testIsTrue = true and
      comp.getGreaterOperand() = upperbound and
      comp.getLesserOperand() = ssaRead(v, D::fromInt(0)) and
      (if comp.isStrict() then isStrict = true else isStrict = false)
      or
      testIsTrue = false and
      comp.getLesserOperand() = upperbound and
      comp.getGreaterOperand() = ssaRead(v, D::fromInt(0)) and
      (if comp.isStrict() then isStrict = false else isStrict = true)
    )
  }

  /**
   * Holds if `eqbound` is an equality/inequality for `v` at `pos`. This is
   * restricted to only include bounds for which we might determine a sign. The
   * boolean `isEq` gives the polarity:
   *  - `isEq = true` : `v = eqbound`
   *  - `isEq = false` : `v != eqbound`
   */
  private predicate eqBound(SemExpr eqbound, SemSsaVariable v, SsaReadPosition pos, boolean isEq) {
    exists(SemGuard guard, boolean testIsTrue, boolean polarity, SemExpr e |
      pos.hasReadOfVar(pragma[only_bind_into](v)) and
      guardControlsSsaRead(guard, pragma[only_bind_into](pos), testIsTrue) and
      e = ssaRead(pragma[only_bind_into](v), D::fromInt(0)) and
      guard.isEquality(eqbound, e, polarity) and
      isEq = polarity.booleanXor(testIsTrue).booleanNot() and
      not unknownSign(eqbound)
    )
  }

  /**
   * Holds if `bound` is a bound for `v` at `pos` that needs to be positive in
   * order for `v` to be positive.
   */
  private predicate posBound(SemExpr bound, SemSsaVariable v, SsaReadPosition pos) {
    upperBound(bound, v, pos, _) or
    eqBound(bound, v, pos, true)
  }

  /**
   * Holds if `bound` is a bound for `v` at `pos` that needs to be negative in
   * order for `v` to be negative.
   */
  private predicate negBound(SemExpr bound, SemSsaVariable v, SsaReadPosition pos) {
    lowerBound(bound, v, pos, _) or
    eqBound(bound, v, pos, true)
  }

  /**
   * Holds if `bound` is a bound for `v` at `pos` that can restrict whether `v`
   * can be zero.
   */
  private predicate zeroBound(SemExpr bound, SemSsaVariable v, SsaReadPosition pos) {
    lowerBound(bound, v, pos, _) or
    upperBound(bound, v, pos, _) or
    eqBound(bound, v, pos, _)
  }

  /** Holds if `bound` allows `v` to be positive at `pos`. */
  private predicate posBoundOk(SemExpr bound, SemSsaVariable v, SsaReadPosition pos) {
    posBound(bound, v, pos) and TPos() = semExprSign(bound)
  }

  /** Holds if `bound` allows `v` to be negative at `pos`. */
  private predicate negBoundOk(SemExpr bound, SemSsaVariable v, SsaReadPosition pos) {
    negBound(bound, v, pos) and TNeg() = semExprSign(bound)
  }

  /** Holds if `bound` allows `v` to be zero at `pos`. */
  private predicate zeroBoundOk(SemExpr bound, SemSsaVariable v, SsaReadPosition pos) {
    lowerBound(bound, v, pos, _) and TNeg() = semExprSign(bound)
    or
    lowerBound(bound, v, pos, false) and TZero() = semExprSign(bound)
    or
    upperBound(bound, v, pos, _) and TPos() = semExprSign(bound)
    or
    upperBound(bound, v, pos, false) and TZero() = semExprSign(bound)
    or
    eqBound(bound, v, pos, true) and TZero() = semExprSign(bound)
    or
    eqBound(bound, v, pos, false) and TZero() != semExprSign(bound)
  }

  /**
   * Holds if there is a bound that might restrict whether `v` has the sign `s`
   * at `pos`.
   */
  private predicate hasGuard(SemSsaVariable v, SsaReadPosition pos, Sign s) {
    s = TPos() and posBound(_, v, pos)
    or
    s = TNeg() and negBound(_, v, pos)
    or
    s = TZero() and zeroBound(_, v, pos)
  }

  /**
   * Gets a possible sign of `v` at `pos` based on its definition, where the sign
   * might be ruled out by a guard.
   */
  pragma[noinline]
  private Sign guardedSsaSign(SemSsaVariable v, SsaReadPosition pos) {
    result = semSsaDefSign(v) and
    pos.hasReadOfVar(v) and
    hasGuard(v, pos, result)
  }

  /**
   * Gets a possible sign of `v` at `pos` based on its definition, where no guard
   * can rule it out.
   */
  pragma[noinline]
  private Sign unguardedSsaSign(SemSsaVariable v, SsaReadPosition pos) {
    result = semSsaDefSign(v) and
    pos.hasReadOfVar(v) and
    not hasGuard(v, pos, result)
  }

  private SemExpr posBoundGetElement(int i, SemSsaVariable v, SsaReadPosition pos) {
    result =
      rank[i + 1](SemExpr bound, SemBasicBlock b, int blockOrder, int indexOrder |
        posBound(bound, v, pos) and
        b = bound.getBasicBlock() and
        blockOrder = b.getUniqueId() and
        bound = b.getInstruction(indexOrder)
      |
        bound order by blockOrder, indexOrder
      )
  }

  private predicate posBoundOkFromIndex(int i, SemSsaVariable v, SsaReadPosition pos) {
    i = 0 and
    posBoundOk(posBoundGetElement(i, v, pos), v, pos)
    or
    posBoundOkFromIndex(i - 1, v, pos) and
    posBoundOk(posBoundGetElement(i, v, pos), v, pos)
  }

  private predicate posBoundGuardedSsaSignOk(SemSsaVariable v, SsaReadPosition pos) {
    posBoundOkFromIndex(max(int i | exists(posBoundGetElement(i, v, pos))), v, pos)
  }

  private SemExpr negBoundGetElement(int i, SemSsaVariable v, SsaReadPosition pos) {
    result =
      rank[i + 1](SemExpr bound, SemBasicBlock b, int blockOrder, int indexOrder |
        negBound(bound, v, pos) and
        b = bound.getBasicBlock() and
        blockOrder = b.getUniqueId() and
        bound = b.getInstruction(indexOrder)
      |
        bound order by blockOrder, indexOrder
      )
  }

  private predicate negBoundOkFromIndex(int i, SemSsaVariable v, SsaReadPosition pos) {
    i = 0 and
    negBoundOk(negBoundGetElement(i, v, pos), v, pos)
    or
    negBoundOkFromIndex(i - 1, v, pos) and
    negBoundOk(negBoundGetElement(i, v, pos), v, pos)
  }

  private predicate negBoundGuardedSsaSignOk(SemSsaVariable v, SsaReadPosition pos) {
    negBoundOkFromIndex(max(int i | exists(negBoundGetElement(i, v, pos))), v, pos)
  }

  private SemExpr zeroBoundGetElement(int i, SemSsaVariable v, SsaReadPosition pos) {
    result =
      rank[i + 1](SemExpr bound, SemBasicBlock b, int blockOrder, int indexOrder |
        zeroBound(bound, v, pos) and
        b = bound.getBasicBlock() and
        blockOrder = b.getUniqueId() and
        bound = b.getInstruction(indexOrder)
      |
        bound order by blockOrder, indexOrder
      )
  }

  private predicate zeroBoundOkFromIndex(int i, SemSsaVariable v, SsaReadPosition pos) {
    i = 0 and
    zeroBoundOk(zeroBoundGetElement(i, v, pos), v, pos)
    or
    zeroBoundOkFromIndex(i - 1, v, pos) and
    zeroBoundOk(zeroBoundGetElement(i, v, pos), v, pos)
  }

  private predicate zeroBoundGuardedSsaSignOk(SemSsaVariable v, SsaReadPosition pos) {
    zeroBoundOkFromIndex(max(int i | exists(zeroBoundGetElement(i, v, pos))), v, pos)
  }

  /**
   * Gets a possible sign of `v` at read position `pos`, where a guard could have
   * ruled out the sign but does not.
   * This does not check that the definition of `v` also allows the sign.
   */
  private Sign guardedSsaSignOk(SemSsaVariable v, SsaReadPosition pos) {
    result = TPos() and
    // optimised version of
    // `forex(SemExpr bound | posBound(bound, v, pos) | posBoundOk(bound, v, pos))`
    posBoundGuardedSsaSignOk(v, pos)
    or
    result = TNeg() and
    // optimised version of
    // `forex(SemExpr bound | negBound(bound, v, pos) | negBoundOk(bound, v, pos))`
    negBoundGuardedSsaSignOk(v, pos)
    or
    result = TZero() and
    // optimised version of
    // `forex(SemExpr bound | zeroBound(bound, v, pos) | zeroBoundOk(bound, v, pos))`
    zeroBoundGuardedSsaSignOk(v, pos)
  }

  /** Gets a possible sign for `v` at `pos`. */
  private Sign semSsaSign(SemSsaVariable v, SsaReadPosition pos) {
    result = unguardedSsaSign(v, pos)
    or
    result = guardedSsaSign(v, pos) and
    result = guardedSsaSignOk(v, pos)
  }

  /** Gets a possible sign for `v`. */
  pragma[nomagic]
  Sign semSsaDefSign(SemSsaVariable v) { result = v.(SignDef).getSign() }

  /** Gets a possible sign for `e`. */
  cached
  Sign semExprSign(SemExpr e) {
    exists(Sign s | s = e.(SignExpr).getSign() |
      if
        Sem::getExprType(e) instanceof SemUnsignedIntegerType and
        s = TNeg() and
        not Specific::ignoreTypeRestrictions(e)
      then result = TPos()
      else result = s
    )
  }

  /**
   * Dummy predicate that holds for any sign. This is added to improve readability
   * of cases where the sign is unrestricted.
   */
  predicate semAnySign(Sign s) { any() }

  /** Holds if `e` can be positive and cannot be negative. */
  predicate semPositive(SemExpr e) {
    semExprSign(e) = TPos() and
    not semExprSign(e) = TNeg()
  }

  /** Holds if `e` can be negative and cannot be positive. */
  predicate semNegative(SemExpr e) {
    semExprSign(e) = TNeg() and
    not semExprSign(e) = TPos()
  }

  /** Holds if `e` is strictly positive. */
  predicate semStrictlyPositive(SemExpr e) {
    semExprSign(e) = TPos() and
    not semExprSign(e) = TNeg() and
    not semExprSign(e) = TZero()
  }

  /** Holds if `e` is strictly negative. */
  predicate semStrictlyNegative(SemExpr e) {
    semExprSign(e) = TNeg() and
    not semExprSign(e) = TPos() and
    not semExprSign(e) = TZero()
  }

  /**
   * Holds if `e` may have positive values. This does not rule out the
   * possibility for negative values.
   */
  predicate semMayBePositive(SemExpr e) { semExprSign(e) = TPos() }

  /**
   * Holds if `e` may have negative values. This does not rule out the
   * possibility for positive values.
   */
  predicate semMayBeNegative(SemExpr e) { semExprSign(e) = TNeg() }
}
