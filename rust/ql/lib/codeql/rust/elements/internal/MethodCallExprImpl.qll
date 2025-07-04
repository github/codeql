/**
 * This module provides a hand-modifiable wrapper around the generated class `MethodCallExpr`.
 *
 * INTERNAL: Do not use.
 */

private import rust
private import codeql.rust.elements.internal.generated.MethodCallExpr
private import codeql.rust.internal.PathResolution
private import codeql.rust.internal.TypeInference

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
    override Function getStaticTarget() { result = resolveMethodCallTarget(this) }

    private string toStringPart(int index) {
      index = 0 and
      result = this.getReceiver().toAbbreviatedString()
      or
      index = 1 and
      (if this.getReceiver().toAbbreviatedString() = "..." then result = " ." else result = ".")
      or
      index = 2 and
      result = this.getIdentifier().toStringImpl()
      or
      index = 3 and
      if this.getArgList().getNumberOfArgs() = 0 then result = "()" else result = "(...)"
    }

    override string toStringImpl() {
      result = strictconcat(int i | | this.toStringPart(i) order by i)
    }
  }
}
