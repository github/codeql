/**
 * Provides some useful .Net classes.
 */

import Element
import Expr

/** A throw element. */
class Throw extends Element, @dotnet_throw {
  /** Gets the expression being thrown, if any. */
  Expr getExpr() { none() }
}
