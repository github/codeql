/**
 * Provides classes for representing abstract bounds for use in, for example, range analysis.
 */

private import internal.rangeanalysis.BoundSpecific

private newtype TBound =
  TBoundZero() or
  TBoundSsa(SsaVariable v) { v.getSourceVariable().getType() instanceof IntegralType } or
  TBoundExpr(Expr e) {
    interestingExprBound(e) and
    not exists(SsaVariable v | e = v.getAUse())
  }

/**
 * A bound that may be inferred for an expression plus/minus an integer delta.
 */
abstract class Bound extends TBound {
  /** Gets a textual representation of this bound. */
  abstract string toString();

  /** Gets an expression that equals this bound plus `delta`. */
  abstract Expr getExpr(int delta);

  /** Gets an expression that equals this bound. */
  Expr getExpr() { result = getExpr(0) }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `sc` of line `sl` to
   * column `ec` of line `el` in file `path`.
   * For more information, see
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
   */
  predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    path = "" and sl = 0 and sc = 0 and el = 0 and ec = 0
  }
}

/**
 * The bound that corresponds to the integer 0. This is used to represent all
 * integer bounds as bounds are always accompanied by an added integer delta.
 */
class ZeroBound extends Bound, TBoundZero {
  override string toString() { result = "0" }

  override Expr getExpr(int delta) { result.(ConstantIntegerExpr).getIntValue() = delta }
}

/**
 * A bound corresponding to the value of an SSA variable.
 */
class SsaBound extends Bound, TBoundSsa {
  /** Gets the SSA variable that equals this bound. */
  SsaVariable getSsa() { this = TBoundSsa(result) }

  override string toString() { result = getSsa().toString() }

  override Expr getExpr(int delta) { result = getSsa().getAUse() and delta = 0 }

  override predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    getSsa().getLocation().hasLocationInfo(path, sl, sc, el, ec)
  }
}

/**
 * A bound that corresponds to the value of a specific expression that might be
 * interesting, but isn't otherwise represented by the value of an SSA variable.
 */
class ExprBound extends Bound, TBoundExpr {
  override string toString() { result = getExpr().toString() }

  override Expr getExpr(int delta) { this = TBoundExpr(result) and delta = 0 }

  override predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    getExpr().getLocation().hasLocationInfo(path, sl, sc, el, ec)
  }
}
