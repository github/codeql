/**
 * This module provides a hand-modifiable wrapper around the generated class `ClosureExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.ClosureExpr

/**
 * INTERNAL: This module contains the customizable definition of `ClosureExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A closure expression. For example:
   * ```rust
   * |x| x + 1;
   * move |x: i32| -> i32 { x + 1 };
   * async |x: i32, y| x + y;
   *  #[coroutine]
   * |x| yield x;
   *  #[coroutine]
   *  static |x| yield x;
   * ```
   */
  class ClosureExpr extends Generated::ClosureExpr {
    override string toString() { result = "|...| " + this.getBody().toAbbreviatedString() }
  }
}
