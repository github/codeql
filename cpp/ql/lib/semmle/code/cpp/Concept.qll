/**
 * Provides classes for working with C++ concepts.
 */

import semmle.code.cpp.exprs.Expr

/**
 * A C++ requires expression.
 */
class RequiresExpr extends Expr, @requires_expr {
  override string toString() { result = "requires ..." }

  override string getAPrimaryQlClass() { result = "RequiresExpr" }
}
