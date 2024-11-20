/**
 * This module provides a hand-modifiable wrapper around the generated class `IfExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.IfExpr

/**
 * INTERNAL: This module contains the customizable definition of `IfExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * An `if` expression. For example:
   * ```rust
   * if x == 42 {
   *     println!("that's the answer");
   * }
   * ```
   * ```rust
   * let y = if x > 0 {
   *     1
   * } else {
   *     0
   * };
   * ```
   */
  class IfExpr extends Generated::IfExpr {
    override string toString() { result = concat(int i | | this.toStringPart(i), " " order by i) }

    private string toStringPart(int index) {
      index = 0 and result = "if"
      or
      index = 1 and result = this.getCondition().toAbbreviatedString()
      or
      index = 2 and result = "{...}"
      or
      index = 3 and this.hasElse() and result = "else {...}"
    }
  }
}
