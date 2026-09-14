/**
 * This module provides a hand-modifiable wrapper around the generated class `AsmRegSpec`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.AsmRegSpec

/**
 * INTERNAL: This module contains the customizable definition of `AsmRegSpec` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A register specification in an inline assembly block.
   *
   * For example:
   * ```rust
   * use core::arch::asm;
   * asm!("mov {0}, {1}", out("eax") x, in(EBX) y);
   * //                        ^^^         ^^^
   * ```
   */
  class AsmRegSpec extends Generated::AsmRegSpec {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
