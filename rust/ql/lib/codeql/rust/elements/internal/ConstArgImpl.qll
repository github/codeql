/**
 * This module provides a hand-modifiable wrapper around the generated class `ConstArg`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.ConstArg

/**
 * INTERNAL: This module contains the customizable definition of `ConstArg` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A constant argument in a generic argument list.
   *
   * For example:
   * ```rust
   * Foo::<3>
   * //    ^
   * ```
   */
  class ConstArg extends Generated::ConstArg {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
