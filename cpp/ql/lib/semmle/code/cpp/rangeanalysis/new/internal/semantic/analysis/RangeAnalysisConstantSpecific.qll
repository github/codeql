/**
 * C++-specific implementation of range analysis.
 */

private import semmle.code.cpp.rangeanalysis.new.internal.semantic.Semantic
private import RangeAnalysisStage
private import semmle.code.cpp.rangeanalysis.new.internal.semantic.analysis.FloatDelta

module CppLangImplConstant implements LangSig<FloatDelta> {
  private newtype TSemReason =
    TSemNoReason() or
    TSemCondReason(SemGuard guard) or
    TSemTypeReason()

  /**
   * A reason for an inferred bound. This can either be `CondReason` if the bound
   * is due to a specific condition, or `NoReason` if the bound is inferred
   * without going through a bounding condition.
   */
  abstract class SemReason extends TSemReason {
    /** Gets a textual representation of this reason. */
    abstract string toString();

    bindingset[this, reason]
    abstract SemReason combineWith(SemReason reason);
  }

  /**
   * A reason for an inferred bound that indicates that the bound is inferred
   * without going through a bounding condition.
   */
  class SemNoReason extends SemReason, TSemNoReason {
    override string toString() { result = "NoReason" }

    override SemReason combineWith(SemReason reason) { result = reason }
  }

  /** A reason for an inferred bound pointing to a condition. */
  class SemCondReason extends SemReason, TSemCondReason {
    /** Gets the condition that is the reason for the bound. */
    SemGuard getCond() { this = TSemCondReason(result) }

    override string toString() { result = this.getCond().toString() }

    bindingset[this, reason]
    override SemReason combineWith(SemReason reason) {
      if reason instanceof SemTypeReason then result instanceof SemTypeReason else result = this
    }
  }

  /**
   * A reason for an inferred bound that indicates that the bound is inferred
   * based on type-information.
   */
  class SemTypeReason extends SemReason, TSemTypeReason {
    override string toString() { result = "TypeReason" }

    override SemReason combineWith(SemReason reason) { result = this and exists(reason) }
  }

  /**
   * Holds if the specified expression should be excluded from the result of `ssaRead()`.
   *
   * This predicate is to keep the results identical to the original Java implementation. It should be
   * removed once we have the new implementation matching the old results exactly.
   */
  predicate ignoreSsaReadCopy(SemExpr e) { none() }

  /**
   * Ignore the bound on this expression.
   *
   * This predicate is to keep the results identical to the original Java implementation. It should be
   * removed once we have the new implementation matching the old results exactly.
   */
  predicate ignoreExprBound(SemExpr e) { none() }

  /**
   * Ignore any inferred zero lower bound on this expression.
   *
   * This predicate is to keep the results identical to the original Java implementation. It should be
   * removed once we have the new implementation matching the old results exactly.
   */
  predicate ignoreZeroLowerBound(SemExpr e) { none() }

  /**
   * Holds if the specified expression should be excluded from the result of `ssaRead()`.
   *
   * This predicate is to keep the results identical to the original Java implementation. It should be
   * removed once we have the new implementation matching the old results exactly.
   */
  predicate ignoreSsaReadArithmeticExpr(SemExpr e) { none() }

  /**
   * Holds if the specified variable should be excluded from the result of `ssaRead()`.
   *
   * This predicate is to keep the results identical to the original Java implementation. It should be
   * removed once we have the new implementation matching the old results exactly.
   */
  predicate ignoreSsaReadAssignment(SemSsaVariable v) { none() }

  /**
   * Adds additional results to `ssaRead()` that are specific to Java.
   *
   * This predicate handles propagation of offsets for post-increment and post-decrement expressions
   * in exactly the same way as the old Java implementation. Once the new implementation matches the
   * old one, we should remove this predicate and propagate deltas for all similar patterns, whether
   * or not they come from a post-increment/decrement expression.
   */
  SemExpr specificSsaRead(SemSsaVariable v, float delta) { none() }

  /**
   * Holds if `e >= bound` (if `upper = false`) or `e <= bound` (if `upper = true`).
   */
  predicate hasConstantBound(SemExpr e, float bound, boolean upper) { none() }

  /**
   * Holds if `e >= bound + delta` (if `upper = false`) or `e <= bound + delta` (if `upper = true`).
   */
  predicate hasBound(SemExpr e, SemExpr bound, float delta, boolean upper) { none() }

  /**
   * Holds if the value of `dest` is known to be `src + delta`.
   */
  predicate additionalValueFlowStep(SemExpr dest, SemExpr src, float delta) { none() }

  /**
   * Gets the type that range analysis should use to track the result of the specified expression,
   * if a type other than the original type of the expression is to be used.
   *
   * This predicate is commonly used in languages that support immutable "boxed" types that are
   * actually references but whose values can be tracked as the type contained in the box.
   */
  SemType getAlternateType(SemExpr e) { none() }

  /**
   * Gets the type that range analysis should use to track the result of the specified source
   * variable, if a type other than the original type of the expression is to be used.
   *
   * This predicate is commonly used in languages that support immutable "boxed" types that are
   * actually references but whose values can be tracked as the type contained in the box.
   */
  SemType getAlternateTypeForSsaVariable(SemSsaVariable var) { none() }
}
