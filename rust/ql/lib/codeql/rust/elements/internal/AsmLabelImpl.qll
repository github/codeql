/**
 * This module provides a hand-modifiable wrapper around the generated class `AsmLabel`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.AsmLabel

/**
 * INTERNAL: This module contains the customizable definition of `AsmLabel` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A label in an inline assembly block.
   *
   * For example:
   * ```rust
   * use core::arch::asm;
   * asm!(
   *     "jmp {}",
   *     label { println!("Jumped from asm!"); }
   * //  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   * );
   * ```
   */
  class AsmLabel extends Generated::AsmLabel {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
