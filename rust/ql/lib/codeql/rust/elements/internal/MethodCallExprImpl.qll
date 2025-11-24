/**
 * This module provides a hand-modifiable wrapper around the generated class `MethodCallExpr`.
 *
 * INTERNAL: Do not use.
 */

private import rust
private import codeql.rust.elements.internal.generated.MethodCallExpr

/**
 * INTERNAL: This module contains the customizable definition of `MethodCallExpr` and should not
 * be referenced directly.
 */
module Impl {
  private import codeql.rust.elements.internal.CallImpl::Impl as CallImpl
  private import codeql.rust.elements.internal.ArgsExprImpl::Impl as ArgsExprImpl

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * NOTE: Consider using `MethodCall` instead, as that also includes calls to methods using
   * function call syntax (such as `Foo::method(x)`), operator calls (such as `x + y`), and
   * indexing calls (such as `x[y]`).
   *
   * A method call expression. For example:
   * ```rust
   * x.foo(42);
   * x.foo::<u32, u64>(42);
   * ```
   */
  class MethodCallExpr extends Generated::MethodCallExpr, CallImpl::MethodCall {
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

    override Expr getSyntacticArgument(int i) {
      i = 0 and result = this.getReceiver()
      or
      result = this.getPositionalArgument(i - 1)
    }

    override Expr getPositionalArgument(int i) { result = this.getArgList().getArg(i) }

    override Expr getReceiver() { result = Generated::MethodCallExpr.super.getReceiver() }
  }
}
