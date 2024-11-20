/**
 * This module provides a hand-modifiable wrapper around the generated class `ParenType`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.ParenType

/**
 * INTERNAL: This module contains the customizable definition of `ParenType` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A ParenType. For example:
   * ```rust
   * todo!()
   * ```
   */
  class ParenType extends Generated::ParenType {
    override string toString() { result = "(" + this.getTy().toAbbreviatedString() + ")" }
  }
}
