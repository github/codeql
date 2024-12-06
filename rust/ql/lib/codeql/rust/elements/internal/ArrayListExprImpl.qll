/**
 * This module provides a hand-modifiable wrapper around the generated class `ArrayListExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.ArrayListExpr
private import codeql.rust.elements.internal.generated.Raw
private import codeql.rust.elements.internal.generated.Synth
private import codeql.rust.elements.Expr

/**
 * INTERNAL: This module contains the customizable definition of `ArrayListExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * An array expression with a list of elements. For example:
   * ```rust
   * [1, 2, 3];
   * ```
   */
  class ArrayListExpr extends Generated::ArrayListExpr {
    override string toString() { result = "[...]" }
  }
}
