/**
 * This module provides a hand-modifiable wrapper around the generated class `AsmConst`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.AsmConst

/**
 * INTERNAL: This module contains the customizable definition of `AsmConst` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A constant operand in an inline assembly block.
   *
   * For example:
   * ```rust
   * use core::arch::asm;
   * asm!("mov eax, {const}", const 42);
   * //                       ^^^^^^^
   * ```
   */
  class AsmConst extends Generated::AsmConst {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
