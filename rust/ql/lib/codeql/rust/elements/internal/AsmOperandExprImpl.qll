/**
 * This module provides a hand-modifiable wrapper around the generated class `AsmOperandExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.AsmOperandExpr

/**
 * INTERNAL: This module contains the customizable definition of `AsmOperandExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * An operand expression in an inline assembly block.
   *
   * For example:
   * ```rust
   * use core::arch::asm;
   * asm!("mov {0}, {1}", out(reg) x, in(reg) y);
   * //                            ^          ^
   * ```
   */
  class AsmOperandExpr extends Generated::AsmOperandExpr {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
