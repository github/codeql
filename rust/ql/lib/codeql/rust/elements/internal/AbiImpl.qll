/**
 * This module provides a hand-modifiable wrapper around the generated class `Abi`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Abi

/**
 * INTERNAL: This module contains the customizable definition of `Abi` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * An ABI specification for an extern function or block.
   *
   * For example:
   * ```rust
   * extern "C" fn foo() {}
   * //     ^^^
   * ```
   */
  class Abi extends Generated::Abi {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
