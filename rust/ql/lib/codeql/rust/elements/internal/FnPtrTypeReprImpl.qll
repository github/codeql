/**
 * This module provides a hand-modifiable wrapper around the generated class `FnPtrTypeRepr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.FnPtrTypeRepr

/**
 * INTERNAL: This module contains the customizable definition of `FnPtrTypeRepr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A function pointer type.
   *
   * For example:
   * ```rust
   * let f: fn(i32) -> i32;
   * //     ^^^^^^^^^^^^^^
   * ```
   */
  class FnPtrTypeRepr extends Generated::FnPtrTypeRepr {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
