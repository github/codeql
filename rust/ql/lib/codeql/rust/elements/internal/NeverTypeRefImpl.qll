/**
 * This module provides a hand-modifiable wrapper around the generated class `NeverTypeRef`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.NeverTypeRef

/**
 * INTERNAL: This module contains the customizable definition of `NeverTypeRef` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A NeverTypeRef. For example:
   * ```rust
   * todo!()
   * ```
   */
  class NeverTypeRef extends Generated::NeverTypeRef {
    override string toString() { result = this.toAbbreviatedString() }

    override string toAbbreviatedString() { result = "!" }
  }
}
