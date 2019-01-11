/**
 * @name Trailing comma in array or object expressions
 * @description Trailing commas in array and object expressions are interpreted differently
 *              by different browsers and should be avoided.
 * @kind problem
 * @problem.severity recommendation
 * @id js/trailing-comma-in-array-or-object
 * @tags portability
 *       external/cwe/cwe-758
 * @precision low
 * @deprecated This is no longer a problem with modern browsers. Deprecated since 1.17.
 */

import javascript

/** An array or object expression. */
class ArrayOrObjectExpr extends Expr {
  ArrayOrObjectExpr() {
    this instanceof ArrayExpr or
    this instanceof ObjectExpr
  }

  /** Holds if this array or object expression has a trailing comma. */
  predicate hasTrailingComma() {
    this.(ArrayExpr).hasTrailingComma() or
    this.(ObjectExpr).hasTrailingComma()
  }

  /** Gets a short description of this expression. */
  string getShortName() {
    if this instanceof ArrayExpr then result = "array expression" else result = "object expression"
  }
}

from ArrayOrObjectExpr e
where e.hasTrailingComma()
select e.getLastToken().getPreviousToken(), "Trailing comma in " + e.getShortName() + "."
