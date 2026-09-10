/**
 * This module provides a hand-modifiable wrapper around the generated class `AsmClobberAbi`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.AsmClobberAbi

/**
 * INTERNAL: This module contains the customizable definition of `AsmClobberAbi` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A clobbered ABI in an inline assembly block.
   *
   * For example:
   * ```rust
   * use core::arch::asm;
   * asm!("", clobber_abi("C"));
   * //       ^^^^^^^^^^^^^^^^
   * ```
   */
  class AsmClobberAbi extends Generated::AsmClobberAbi {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
