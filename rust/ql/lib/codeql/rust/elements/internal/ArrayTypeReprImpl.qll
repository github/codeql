/**
 * This module provides a hand-modifiable wrapper around the generated class `ArrayTypeRepr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.ArrayTypeRepr

/**
 * INTERNAL: This module contains the customizable definition of `ArrayTypeRepr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * An array type representation.
   *
   * For example:
   * ```rust
   * let arr: [i32; 4];
   * //       ^^^^^^^^
   * ```
   */
  class ArrayTypeRepr extends Generated::ArrayTypeRepr {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
