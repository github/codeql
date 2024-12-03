/**
 * This module provides a hand-modifiable wrapper around the generated class `ParenTypeRepr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.ParenTypeRepr

/**
 * INTERNAL: This module contains the customizable definition of `ParenTypeRepr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A ParenTypeRepr. For example:
   * ```rust
   * todo!()
   * ```
   */
  class ParenTypeRepr extends Generated::ParenTypeRepr {
    override string toString() { result = "(" + this.getTypeRepr().toAbbreviatedString() + ")" }
  }
}
