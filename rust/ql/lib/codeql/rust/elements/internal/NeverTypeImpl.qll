/**
 * This module provides a hand-modifiable wrapper around the generated class `NeverType`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.NeverType

/**
 * INTERNAL: This module contains the customizable definition of `NeverType` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A NeverType. For example:
   * ```rust
   * todo!()
   * ```
   */
  class NeverType extends Generated::NeverType {
    override string toString() { result = this.toAbbreviatedString() }

    override string toAbbreviatedString() { result = "!" }
  }
}
