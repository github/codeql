/**
 * This module provides a hand-modifiable wrapper around the generated class `AsmOptionsList`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.AsmOptionsList

/**
 * INTERNAL: This module contains the customizable definition of `AsmOptionsList` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A list of options in an inline assembly block.
   *
   * For example:
   * ```rust
   * use core::arch::asm;
   * asm!("", options(nostack, nomem));
   * //              ^^^^^^^^^^^^^^^^
   * ```
   */
  class AsmOptionsList extends Generated::AsmOptionsList {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
