/**
 * This module provides a hand-modifiable wrapper around the generated class `ParenTypeRef`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.ParenTypeRef

/**
 * INTERNAL: This module contains the customizable definition of `ParenTypeRef` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A ParenTypeRef. For example:
   * ```rust
   * todo!()
   * ```
   */
  class ParenTypeRef extends Generated::ParenTypeRef {
    override string toString() { result = "(" + this.getTy().toAbbreviatedString() + ")" }
  }
}
