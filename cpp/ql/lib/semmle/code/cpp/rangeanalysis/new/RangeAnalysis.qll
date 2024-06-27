/**
 * Provides an AST-based interface to the relative range analysis, which tracks bounds of the form
 * `a <= b + delta` for expressions `a` and `b` and an integer offset `delta`.
 */

private import semmle.code.cpp.rangeanalysis.new.internal.semantic.analysis.RangeAnalysis
private import cpp
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.controlflow.IRGuards
private import semmle.code.cpp.rangeanalysis.new.internal.semantic.SemanticExpr
private import semmle.code.cpp.rangeanalysis.new.internal.semantic.SemanticExprSpecific
private import semmle.code.cpp.rangeanalysis.new.internal.semantic.analysis.Bound as IRBound
private import semmle.code.cpp.valuenumbering.GlobalValueNumbering

/**
 * Holds if e is bounded by `b + delta`. The bound is an upper bound if
 * `upper` is true, and can be traced back to a guard represented by `reason`.
 */
predicate bounded(Expr e, Bound b, float delta, boolean upper, Reason reason) {
  exists(SemanticExprConfig::Expr semExpr | semExpr.getUnconvertedResultExpression() = e |
    semBounded(semExpr, b, delta, upper, reason)
  )
}

/**
 * Holds if e is bounded by `b + delta`. The bound is an upper bound if
 * `upper` is true, and can be traced back to a guard represented by `reason`.
 * The `Expr` may be a conversion.
 */
predicate convertedBounded(Expr e, Bound b, float delta, boolean upper, Reason reason) {
  exists(SemanticExprConfig::Expr semExpr | semExpr.getConvertedResultExpression() = e |
    semBounded(semExpr, b, delta, upper, reason)
  )
}

/**
 * A reason for an inferred bound. This can either be `CondReason` if the bound
 * is due to a specific condition, or `NoReason` if the bound is inferred
 * without going through a bounding condition.
 */
class Reason instanceof SemReason {
  /** Gets a string representation of this reason */
  string toString() { none() }
}

/**
 * A reason for an inferred bound that indicates that the bound is inferred
 * without going through a bounding condition.
 */
class NoReason extends Reason instanceof SemNoReason {
  override string toString() { result = "NoReason" }
}

/** A reason for an inferred bound pointing to a condition. */
class CondReason extends Reason instanceof SemCondReason {
  override string toString() { result = SemCondReason.super.toString() }

  /** Gets the guard condition that caused the inferred bound */
  GuardCondition getCond() {
    result = super.getCond().(IRGuardCondition).getUnconvertedResultExpression()
  }
}

/**
 * A bound that may be inferred for an expression plus/minus an integer delta.
 */
class Bound instanceof IRBound::Bound {
  /** Gets a string representation of this bound. */
  string toString() { none() }

  /** Gets an expression that equals this bound. */
  Expr getAnExpr() { none() }

  /** Gets an expression that equals this bound plus `delta`. */
  Expr getAnExpr(int delta) { none() }

  /** Gets a representative locaiton for this bound */
  Location getLocation() { none() }
}

/**
 * The bound that corresponds to the integer 0. This is used to represent all
 * integer bounds as bounds are always accompanied by an added integer delta.
 */
class ZeroBound extends Bound instanceof IRBound::ZeroBound {
  override string toString() { result = "0" }

  override Expr getAnExpr(int delta) {
    result = super.getInstruction(delta).getUnconvertedResultExpression()
  }

  override Location getLocation() { result instanceof UnknownDefaultLocation }
}

/**
 * A bound corresponding to the value of an `Instruction`.
 */
class ValueNumberBound extends Bound instanceof IRBound::ValueNumberBound {
  override string toString() { result = "ValueNumberBound" }

  override Expr getAnExpr(int delta) {
    result = super.getInstruction(delta).getUnconvertedResultExpression()
  }

  override Location getLocation() { result = IRBound::ValueNumberBound.super.getLocation() }

  /** Gets the value number that equals this bound. */
  GVN getValueNumber() { result = super.getValueNumber() }
}
