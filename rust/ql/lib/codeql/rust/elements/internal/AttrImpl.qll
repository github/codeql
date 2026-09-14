/**
 * This module provides a hand-modifiable wrapper around the generated class `Attr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Attr

/**
 * INTERNAL: This module contains the customizable definition of `Attr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * An attribute applied to an item.
   *
   * For example:
   * ```rust
   * #[derive(Debug)]
   * //^^^^^^^^^^^^^
   * struct S;
   * ```
   */
  class Attr extends Generated::Attr {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
