/**
 * This module provides the public class `Call`.
 */

private import rust
private import internal.CallImpl

final class Call = Impl::Call;

private predicate isClosureCall(CallExpr call) {
  exists(Expr receiver | receiver = call.getFunction() |
    // All calls to complex expressions and local variable accesses are lambda calls
    receiver instanceof PathExpr implies receiver = any(Variable v).getAnAccess()
  )
}

/**
 * Holds if `call` is guaranteed to be a method call, even if we cannot resolve
 * its target.
 */
private predicate isGuaranteedMethodCall(Call call) {
  call instanceof MethodCallExpr
  or
  call.(Operation).isOverloaded(_, _, _)
  or
  call instanceof IndexExpr
}

/**
 * A call expression that targets a function or a closure.
 *
 * For example, call expressions like `Some(42)` and `x && y` are _not_ function calls.
 */
final class FunctionCall extends Call {
  FunctionCall() {
    this.getStaticTarget() instanceof Function
    or
    isClosureCall(this)
    or
    isGuaranteedMethodCall(this)
  }

  /** Gets the static target of this function call, if any. */
  Function getStaticTarget() { result = super.getStaticTarget() }
}

/**
 * A call expression that targets a method.
 */
final class MethodCall extends FunctionCall {
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
final class ClosureCall extends FunctionCall, CallExpr {
  ClosureCall() { isClosureCall(this) }
}
