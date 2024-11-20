/**
 * This module provides a hand-modifiable wrapper around the generated class `ParenPat`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.ParenPat

/**
 * INTERNAL: This module contains the customizable definition of `ParenPat` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A ParenPat. For example:
   * ```rust
   * todo!()
   * ```
   */
  class ParenPat extends Generated::ParenPat {
    override string toString() { result = "(" + this.getPat().toAbbreviatedString() + ")" }
  }
}
