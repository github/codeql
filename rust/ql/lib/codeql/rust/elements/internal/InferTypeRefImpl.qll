/**
 * This module provides a hand-modifiable wrapper around the generated class `InferTypeRef`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.InferTypeRef

/**
 * INTERNAL: This module contains the customizable definition of `InferTypeRef` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A InferTypeRef. For example:
   * ```rust
   * todo!()
   * ```
   */
  class InferTypeRef extends Generated::InferTypeRef {
    override string toString() { result = this.toAbbreviatedString() }

    override string toAbbreviatedString() { result = "_" }
  }
}
