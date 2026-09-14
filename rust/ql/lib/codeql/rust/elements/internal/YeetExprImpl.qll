/**
 * This module provides a hand-modifiable wrapper around the generated class `YeetExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.YeetExpr

/**
 * INTERNAL: This module contains the customizable definition of `YeetExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A `yeet` expression. For example:
   * ```rust
   * if x < size {
   *    do yeet "index out of bounds";
   * }
   * ```
   */
  class YeetExpr extends Generated::YeetExpr {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
