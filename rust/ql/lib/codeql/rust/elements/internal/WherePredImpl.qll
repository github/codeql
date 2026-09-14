/**
 * This module provides a hand-modifiable wrapper around the generated class `WherePred`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.WherePred

/**
 * INTERNAL: This module contains the customizable definition of `WherePred` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A predicate in a where clause.
   *
   * For example:
   * ```rust
   * fn foo<T, U>(t: T, u: U) where T: Debug, U: Clone {}
   * //                             ^^^^^^^^  ^^^^^^^^
   * fn bar<T>(value: T) where for<'a> T: From<&'a str> {}
   * //                        ^^^^^^^^^^^^^^^^^^^^^^^^
   * ```
   */
  class WherePred extends Generated::WherePred {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
