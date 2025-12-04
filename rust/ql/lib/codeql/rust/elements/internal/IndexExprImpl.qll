/**
 * This module provides a hand-modifiable wrapper around the generated class `IndexExpr`.
 *
 * INTERNAL: Do not use.
 */

private import rust
private import codeql.rust.elements.internal.generated.IndexExpr

/**
 * INTERNAL: This module contains the customizable definition of `IndexExpr` and should not
 * be referenced directly.
 */
module Impl {
  private import codeql.rust.elements.internal.CallImpl::Impl as CallImpl

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * An index expression. For example:
   * ```rust
   * list[42];
   * list[42] = 1;
   * ```
   */
  class IndexExpr extends Generated::IndexExpr, CallImpl::MethodCall {
    override string toStringImpl() {
      result =
        this.getBase().toAbbreviatedString() + "[" + this.getIndex().toAbbreviatedString() + "]"
    }

    override Expr getSyntacticPositionalArgument(int i) {
      i = 0 and result = this.getBase()
      or
      i = 1 and result = this.getIndex()
    }

    override Expr getPositionalArgument(int i) { i = 0 and result = this.getIndex() }

    override Expr getReceiver() { result = this.getBase() }
  }
}
