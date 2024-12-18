/**
 * This module provides a hand-modifiable wrapper around the generated class `ForExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.ForExpr

/**
 * INTERNAL: This module contains the customizable definition of `ForExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A ForExpr. For example:
   * ```rust
   * todo!()
   * ```
   */
  class ForExpr extends Generated::ForExpr {
    override string toStringPrefix() {
      result = "for " + this.getPat().toAbbreviatedString() + " in ..."
    }
  }
}
