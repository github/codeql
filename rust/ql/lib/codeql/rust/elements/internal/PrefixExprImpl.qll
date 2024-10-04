/**
 * This module provides a hand-modifiable wrapper around the generated class `PrefixExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.PrefixExpr

/**
 * INTERNAL: This module contains the customizable definition of `PrefixExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A unary operation expression. For example:
   * ```rust
   * let x = -42;
   * let y = !true;
   * let z = *ptr;
   * ```
   */
  class PrefixExpr extends Generated::PrefixExpr {
    override string toString() { result = this.getOperatorName() + " ..." }
  }
}
