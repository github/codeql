/**
 * This module provides a hand-modifiable wrapper around the generated class `Rename`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Rename

/**
 * INTERNAL: This module contains the customizable definition of `Rename` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A rename in a use declaration.
   *
   * For example:
   * ```rust
   * use foo as bar;
   * //      ^^^^^^
   * ```
   */
  class Rename extends Generated::Rename {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
