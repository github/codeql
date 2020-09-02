private import csharp
private import Ssa
private import semmle.code.csharp.dataflow.internal.rangeanalysis.ConstantUtils

private newtype TBound =
  TBoundZero() or
  TBoundSsa(Definition v) { v.getSourceVariable().getType() instanceof IntegralType }

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
class DefinitionBound extends Bound, TBoundSsa {
  /** Gets the SSA variable that equals this bound. */
  Definition getDefinition() { this = TBoundSsa(result) }

  override string toString() { result = getDefinition().toString() }

  override Expr getExpr(int delta) { result = getDefinition().getARead() and delta = 0 }

  override predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    getDefinition().getLocation().hasLocationInfo(path, sl, sc, el, ec)
  }
}
