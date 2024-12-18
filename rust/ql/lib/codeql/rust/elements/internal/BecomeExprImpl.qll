/**
 * This module provides a hand-modifiable wrapper around the generated class `BecomeExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.BecomeExpr

/**
 * INTERNAL: This module contains the customizable definition of `BecomeExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A `become` expression. For example:
   * ```rust
   * fn fact_a(n: i32, a: i32) -> i32 {
   *      if n == 0 {
   *          a
   *      } else {
   *          become fact_a(n - 1, n * a)
   *      }
   * }
   * ```
   */
  class BecomeExpr extends Generated::BecomeExpr {
    override string toString() { result = "become " + this.getExpr().toAbbreviatedString() }
  }
}
