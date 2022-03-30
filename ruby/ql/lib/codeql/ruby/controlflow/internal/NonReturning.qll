/** Provides a simple analysis for identifying calls that will not return. */

private import codeql.ruby.AST
private import Completion

/** A call that definitely does not return (conservative analysis). */
abstract class NonReturningCall extends MethodCall {
  /** Gets a valid completion for this non-returning call. */
  abstract Completion getACompletion();
}

private class RaiseCall extends NonReturningCall {
  RaiseCall() { this.getMethodName() = "raise" }

  override RaiseCompletion getACompletion() { not result instanceof NestedCompletion }
}

private class ExitCall extends NonReturningCall {
  ExitCall() { this.getMethodName() in ["abort", "exit"] }

  override ExitCompletion getACompletion() { not result instanceof NestedCompletion }
}
