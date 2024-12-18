/**
 * This module provides a hand-modifiable wrapper around the generated class `WhileExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.WhileExpr

/**
 * INTERNAL: This module contains the customizable definition of `WhileExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A WhileExpr. For example:
   * ```rust
   * todo!()
   * ```
   */
  class WhileExpr extends Generated::WhileExpr {
    override string toStringPrefix() {
      result = "while " + this.getCondition().toAbbreviatedString()
    }
  }
}
