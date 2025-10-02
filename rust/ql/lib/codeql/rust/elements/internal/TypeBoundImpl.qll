/**
 * This module provides a hand-modifiable wrapper around the generated class `TypeBound`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.TypeBound

/**
 * INTERNAL: This module contains the customizable definition of `TypeBound` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A type bound in a trait or generic parameter.
   *
   * For example:
   * ```rust
   * fn foo<T: Debug>(t: T) {}
   * //        ^^^^^
   * fn bar(value: impl for<'a> From<&'a str>) {}
   * //                 ^^^^^^^^^^^^^^^^^^^^^
   * ```
   */
  class TypeBound extends Generated::TypeBound {
    override string toAbbreviatedString() {
      result = this.getLifetime().toAbbreviatedString()
      or
      not this.hasLifetime() and
      result = "..."
    }
  }
}
