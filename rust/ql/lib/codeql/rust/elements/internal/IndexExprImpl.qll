/**
 * This module provides a hand-modifiable wrapper around the generated class `IndexExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.IndexExpr

/**
 * INTERNAL: This module contains the customizable definition of `IndexExpr` and should not
 * be referenced directly.
 */
module Impl {
  private import codeql.rust.elements.internal.CallLikeExprImpl::Impl as CallLikeExprImpl

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * An index expression. For example:
   * ```rust
   * list[42];
   * list[42] = 1;
   * ```
   */
  class IndexExpr extends Generated::IndexExpr, CallLikeExprImpl::CallLikeExpr {
    override string toStringImpl() {
      result =
        this.getBase().toAbbreviatedString() + "[" + this.getIndex().toAbbreviatedString() + "]"
    }

    override Expr getArgument(int i) { i = 0 and result = this.getIndex() }

    override Expr getReceiver() { result = this.getBase() }
  }
}
