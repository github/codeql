/**
 * This module provides a hand-modifiable wrapper around the generated class `YieldExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.YieldExpr

/**
 * INTERNAL: This module contains the customizable definition of `YieldExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A `yield` expression. For example:
   * ```rust
   * let one = #[coroutine]
   *     || {
   *         yield 1;
   *     };
   * ```
   */
  class YieldExpr extends Generated::YieldExpr {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
