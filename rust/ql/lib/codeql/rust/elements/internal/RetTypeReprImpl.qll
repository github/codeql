/**
 * This module provides a hand-modifiable wrapper around the generated class `RetTypeRepr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.RetTypeRepr

/**
 * INTERNAL: This module contains the customizable definition of `RetTypeRepr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A return type in a function signature.
   *
   * For example:
   * ```rust
   * fn foo() -> i32 { 0 }
   * //       ^^^^^^
   * ```
   */
  class RetTypeRepr extends Generated::RetTypeRepr {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
