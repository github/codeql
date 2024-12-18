/**
 * This module provides a hand-modifiable wrapper around the generated class `CastExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.CastExpr

/**
 * INTERNAL: This module contains the customizable definition of `CastExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A type cast expression. For example:
   * ```rust
   * value as u64;
   * ```
   */
  class CastExpr extends Generated::CastExpr {
    override string toString() {
      result =
        this.getExpr().toAbbreviatedString() + " as " + this.getTypeRepr().toAbbreviatedString()
    }
  }
}
