/**
 * This module provides a hand-modifiable wrapper around the generated class `AsmExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.AsmExpr

/**
 * INTERNAL: This module contains the customizable definition of `AsmExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * An inline assembly expression. For example:
   * ```rust
   * unsafe {
   *     #[inline(always)]
   *     builtin # asm("cmp {0}, {1}", in(reg) a, in(reg) b);
   * }
   * ```
   */
  class AsmExpr extends Generated::AsmExpr {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
