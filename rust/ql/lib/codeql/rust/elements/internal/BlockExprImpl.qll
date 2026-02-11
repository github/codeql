/**
 * This module provides a hand-modifiable wrapper around the generated class `BlockExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.BlockExpr

/**
 * INTERNAL: This module contains the customizable definition of `BlockExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A block expression. For example:
   * ```rust
   * {
   *     let x = 42;
   * }
   * ```
   * ```rust
   * 'label: {
   *     let x = 42;
   *     x
   * }
   * ```
   */
  class BlockExpr extends Generated::BlockExpr {
    /**
     * Gets the tail expression of this block, if it exists.
     */
    Expr getTailExpr() { result = this.getStmtList().getTailExpr() }
  }
}
