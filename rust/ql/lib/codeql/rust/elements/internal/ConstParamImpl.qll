/**
 * This module provides a hand-modifiable wrapper around the generated class `ConstParam`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.ConstParam

/**
 * INTERNAL: This module contains the customizable definition of `ConstParam` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A constant parameter in a generic parameter list.
   *
   * For example:
   * ```rust
   * struct Foo <const N: usize>;
   * //          ^^^^^^^^^^^^^^
   * ```
   */
  class ConstParam extends Generated::ConstParam {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
