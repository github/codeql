/**
 * This module provides a hand-modifiable wrapper around the generated class `RefTypeRepr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.RefTypeRepr

/**
 * INTERNAL: This module contains the customizable definition of `RefTypeRepr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A reference type.
   *
   * For example:
   * ```rust
   * let r: &i32;
   * let m: &mut i32;
   * //     ^^^^^^^^
   * ```
   */
  class RefTypeRepr extends Generated::RefTypeRepr {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
