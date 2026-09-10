/**
 * This module provides a hand-modifiable wrapper around the generated class `LifetimeArg`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.LifetimeArg

/**
 * INTERNAL: This module contains the customizable definition of `LifetimeArg` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A lifetime argument in a generic argument list.
   *
   * For example:
   * ```rust
   * let text: Text<'a>;
   * //             ^^
   * ```
   */
  class LifetimeArg extends Generated::LifetimeArg {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
