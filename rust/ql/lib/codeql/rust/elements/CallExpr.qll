/**
 * This module provides the public class `Call`.
 */

private import rust
private import internal.CallExprImpl

final class CallExpr = Impl::CallExpr;

private predicate isClosureCall(ParenArgsExpr call) {
  exists(Expr receiver | receiver = call.getBase() |
    // All calls to complex expressions and local variable accesses are lambda calls
    receiver instanceof PathExpr implies receiver = any(Variable v).getAnAccess()
  )
}

/**
 * Holds if `call` is guaranteed to be a method call, even if we cannot resolve
 * its target.
 */
private predicate isGuaranteedMethodCall(CallLikeExpr call) {
  call instanceof MethodCallExpr
  or
  call.(Operation).isOverloaded(_, _, _)
  or
  call instanceof IndexExpr
}

/**
 * A call expression that targets a method.
 */
final class MethodCall extends CallExpr {
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
 * For closure calls, the static target never exists.
 */
final class ClosureCallExpr extends CallExpr instanceof ParenArgsExpr {
  ClosureCallExpr() { isClosureCall(this) }

  /** Gets the closure expression being called. */
  Expr getClosureExpr() { result = super.getBase() }
}
