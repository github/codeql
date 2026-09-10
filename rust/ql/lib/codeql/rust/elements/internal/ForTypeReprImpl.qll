/**
 * This module provides a hand-modifiable wrapper around the generated class `ForTypeRepr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.ForTypeRepr

/**
 * INTERNAL: This module contains the customizable definition of `ForTypeRepr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A function pointer type with a `for` modifier.
   *
   * For example:
   * ```rust
   * type RefOp<X> = for<'a> fn(&'a X) -> &'a X;
   * //              ^^^^^^^^^^^^^^^^^^^^^^^^^^
   * ```
   */
  class ForTypeRepr extends Generated::ForTypeRepr {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
