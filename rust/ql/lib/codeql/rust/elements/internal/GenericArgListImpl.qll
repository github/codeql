/**
 * This module provides a hand-modifiable wrapper around the generated class `GenericArgList`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.GenericArgList

/**
 * INTERNAL: This module contains the customizable definition of `GenericArgList` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * The base class for generic arguments.
   * ```rust
   * x.foo::<u32, u64>(42);
   * ```
   */
  class GenericArgList extends Generated::GenericArgList {
    override string toString() { result = this.toAbbreviatedString() }

    override string toAbbreviatedString() { result = "<...>" }
  }
}
