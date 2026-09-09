/**
 * This module provides a hand-modifiable wrapper around the generated class `ExternBlock`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.ExternBlock

/**
 * INTERNAL: This module contains the customizable definition of `ExternBlock` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * An extern block containing foreign function declarations.
   *
   * For example:
   * ```rust
   * extern "C" {
   *     fn foo();
   * }
   * ```
   */
  class ExternBlock extends Generated::ExternBlock {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
