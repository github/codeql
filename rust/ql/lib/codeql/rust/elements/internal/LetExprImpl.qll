/**
 * This module provides a hand-modifiable wrapper around the generated class `LetExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.LetExpr

/**
 * INTERNAL: This module contains the customizable definition of `LetExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A `let` expression. For example:
   * ```rust
   * if let Some(x) = maybe_some {
   *     println!("{}", x);
   * }
   * ```
   */
  class LetExpr extends Generated::LetExpr {
    override string toString() { result = concat(int i | | this.toStringPart(i), " " order by i) }

    private string toStringPart(int index) {
      index = 0 and result = "let"
      or
      index = 1 and result = this.getPat().toAbbreviatedString()
      or
      index = 2 and result = "= " + this.getScrutinee().toAbbreviatedString()
    }
  }
}
