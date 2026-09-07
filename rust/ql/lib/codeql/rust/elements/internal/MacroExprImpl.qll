/**
 * This module provides a hand-modifiable wrapper around the generated class `MacroExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.MacroExpr

/**
 * INTERNAL: This module contains the customizable definition of `MacroExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A macro expression, representing the invocation of a macro that produces an expression.
   *
   * For example:
   * ```rust
   * let y = vec![1, 2, 3];
   * ```
   */
  class MacroExpr extends Generated::MacroExpr {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
