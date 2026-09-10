/**
 * This module provides a hand-modifiable wrapper around the generated class `SliceTypeRepr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.SliceTypeRepr

/**
 * INTERNAL: This module contains the customizable definition of `SliceTypeRepr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A slice type.
   *
   * For example:
   * ```rust
   * let s: &[i32];
   * //      ^^^^^
   * ```
   */
  class SliceTypeRepr extends Generated::SliceTypeRepr {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
