/**
 * This module provides a hand-modifiable wrapper around the generated class `ReturnExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.ReturnExpr

/**
 * INTERNAL: This module contains the customizable definition of `ReturnExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A return expression. For example:
   * ```rust
   * fn some_value() -> i32 {
   *     return 42;
   * }
   * ```
   * ```rust
   * fn no_value() -> () {
   *     return;
   * }
   * ```
   */
  class ReturnExpr extends Generated::ReturnExpr {
    override string toString() { result = concat(int i | | this.toStringPart(i), " " order by i) }

    private string toStringPart(int index) {
      index = 0 and result = "return"
      or
      index = 1 and result = this.getExpr().toAbbreviatedString()
    }
  }
}
