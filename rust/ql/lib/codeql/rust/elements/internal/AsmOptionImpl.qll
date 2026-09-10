/**
 * This module provides a hand-modifiable wrapper around the generated class `AsmOption`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.AsmOption

/**
 * INTERNAL: This module contains the customizable definition of `AsmOption` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * An option in an inline assembly block.
   *
   * For example:
   * ```rust
   * use core::arch::asm;
   * asm!("", options(nostack, nomem));
   * //              ^^^^^^^^^^^^^^^^
   * ```
   */
  class AsmOption extends Generated::AsmOption {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
