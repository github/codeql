/**
 * This module provides a hand-modifiable wrapper around the generated class `ExternCrate`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.ExternCrate

/**
 * INTERNAL: This module contains the customizable definition of `ExternCrate` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * An extern crate declaration.
   *
   * For example:
   * ```rust
   * extern crate serde;
   * ```
   */
  class ExternCrate extends Generated::ExternCrate {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
