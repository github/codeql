/**
 * This module provides a hand-modifiable wrapper around the generated class `CallExprBase`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.CallExprBase
private import codeql.rust.elements.Resolvable

/**
 * INTERNAL: This module contains the customizable definition of `CallExprBase` and should not
 * be referenced directly.
 */
module Impl {
  private import codeql.rust.elements.internal.CallableImpl::Impl
  private import codeql.rust.elements.internal.MethodCallExprImpl::Impl
  private import codeql.rust.elements.internal.CallExprImpl::Impl
  private import codeql.rust.elements.internal.PathExprImpl::Impl
  private import codeql.rust.elements.internal.PathResolution

  pragma[nomagic]
  Resolvable getCallResolvable(CallExprBase call) {
    result = call.(MethodCallExpr)
    or
    result = call.(CallExpr).getFunction().(PathExpr)
  }

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A function or method call expression. See `CallExpr` and `MethodCallExpr` for further details.
   */
  class CallExprBase extends Generated::CallExprBase {
    /**
     * Gets the target callable of this call, if a unique such target can
     * be statically resolved.
     */
    Callable getStaticTarget() {
      getCallResolvable(this).resolvesAsItem(result)
      or
      result = resolvePath(this.(CallExpr).getFunction().(PathExpr).getPath())
    }
  }
}
