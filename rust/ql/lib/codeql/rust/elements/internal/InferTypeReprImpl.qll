/**
 * This module provides a hand-modifiable wrapper around the generated class `InferTypeRepr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.InferTypeRepr

/**
 * INTERNAL: This module contains the customizable definition of `InferTypeRepr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A InferTypeRepr. For example:
   * ```rust
   * todo!()
   * ```
   */
  class InferTypeRepr extends Generated::InferTypeRepr {
    override string toString() { result = this.toAbbreviatedString() }

    override string toAbbreviatedString() { result = "_" }
  }
}
