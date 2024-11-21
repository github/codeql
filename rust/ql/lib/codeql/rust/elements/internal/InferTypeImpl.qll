/**
 * This module provides a hand-modifiable wrapper around the generated class `InferType`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.InferType

/**
 * INTERNAL: This module contains the customizable definition of `InferType` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A InferType. For example:
   * ```rust
   * todo!()
   * ```
   */
  class InferType extends Generated::InferType {
    override string toString() { result = this.toAbbreviatedString() }

    override string toAbbreviatedString() { result = "_" }
  }
}
