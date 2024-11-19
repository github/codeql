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
    override string toString() {
      exists(string expr |
        (if this.hasExpr() then expr = " = ..." else expr = "") and
        result = "let " + this.getPat().toString() + expr
      )
    }
  }
}
