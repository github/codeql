/**
 * This module provides a hand-modifiable wrapper around the generated class `CallExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.CallExpr
private import codeql.rust.elements.PathExpr

/**
 * INTERNAL: This module contains the customizable definition of `CallExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A function call expression. For example:
   * ```rust
   * foo(42);
   * foo::<u32, u64>(42);
   * foo[0](42);
   * foo(1) = 4;
   * ```
   */
  class CallExpr extends Generated::CallExpr {
    override string toString() { result = this.getFunction().toAbbreviatedString() + "(...)" }
  }
}
