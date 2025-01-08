/**
 * This module provides a hand-modifiable wrapper around the generated class `MethodCallExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.MethodCallExpr

/**
 * INTERNAL: This module contains the customizable definition of `MethodCallExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A method call expression. For example:
   * ```rust
   * x.foo(42);
   * x.foo::<u32, u64>(42);
   * ```
   */
  class MethodCallExpr extends Generated::MethodCallExpr {
    override string toString() {
      exists(string base, string separator |
        base = this.getReceiver().toAbbreviatedString() and
        (if base = "..." then separator = " ." else separator = ".") and
        result = base + separator + this.getNameRef().toString() + "(...)"
      )
    }
  }
}
