/**
 * This module provides a hand-modifiable wrapper around the generated class `AwaitExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.AwaitExpr

/**
 * INTERNAL: This module contains the customizable definition of `AwaitExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * An `await` expression. For example:
   * ```rust
   * async {
   *     let x = foo().await;
   *     x
   * }
   * ```
   */
  class AwaitExpr extends Generated::AwaitExpr {
    override string toString() { result = "await " + this.getExpr().toAbbreviatedString() }
  }
}
