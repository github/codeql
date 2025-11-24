/**
 * This module provides the public class `Call`.
 */

private import rust
private import internal.CallImpl
private import internal.CallExprImpl::Impl as CallExprImpl

final class Call = Impl::Call;

private predicate isGuaranteedMethodCall(ArgsExpr call) {
  call instanceof MethodCallExpr
  or
  call.(Operation).isOverloaded(_, _, _)
  or
  call instanceof IndexExpr
}

/**
 * A call expression that targets a method.
 *
 * Either
 *
 * - a `CallExpr` where we can resolve the target as a method,
 * - a `MethodCallExpr`,
 * - an `Operation` that targets an overloadable operator, or
 * - an `IndexExpr`.
 */
final class MethodCall extends Call {
  MethodCall() {
    this.getStaticTarget() instanceof Method
    or
    isGuaranteedMethodCall(this)
  }

  /** Gets the static target of this method call, if any. */
  Method getStaticTarget() { result = super.getStaticTarget() }
}

/**
 * A call expression that targets a closure.
 *
 * Closure calls never have a static target, and the set of potential
 * run-time targets is only available internally to the data flow library.
 */
class ClosureCallExpr extends CallExprImpl::CallExprCall {
  ClosureCallExpr() {
    exists(Expr receiver | receiver = this.getFunction() |
      // All calls to complex expressions and local variable accesses are lambda calls
      receiver instanceof PathExpr implies receiver = any(Variable v).getAnAccess()
    )
  }

  /** Gets the closure expression being called. */
  Expr getClosureExpr() { result = super.getFunction() }
}
