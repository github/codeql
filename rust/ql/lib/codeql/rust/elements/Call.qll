/**
 * This module provides the public class `Call`.
 */

private import rust
private import internal.CallImpl
private import internal.CallExprImpl::Impl as CallExprImpl

final class Call = Impl::Call;

final class MethodCall = Impl::MethodCall;

/**
 * A call expression that targets a closure.
 *
 * Closure calls never have a static target, and the set of potential
 * run-time targets is only available internally to the data flow library.
 */
class ClosureCallExpr extends CallExprImpl::CallExprCall {
  ClosureCallExpr() {
    exists(Expr f | f = this.getFunction() |
      // All calls to complex expressions and local variable accesses are lambda calls
      f instanceof PathExpr implies f = any(Variable v).getAnAccess()
    )
  }

  /** Gets the closure expression being called. */
  Expr getClosureExpr() { result = super.getFunction() }
}
