/**
 * This module provides a hand-modifiable wrapper around the generated class `LifetimeParam`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.LifetimeParam

/**
 * INTERNAL: This module contains the customizable definition of `LifetimeParam` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A lifetime parameter in a generic parameter list.
   *
   * For example:
   * ```rust
   * fn foo<'a>(x: &'a str) {}
   * //     ^^
   * ```
   */
  class LifetimeParam extends Generated::LifetimeParam {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
