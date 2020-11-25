/** Provides a simple analysis for identifying calls that will not return. */

private import codeql_ruby.Generated::Generated
private import Completion

/** A call that definitely does not return (conservative analysis). */
abstract class NonReturningCall extends AstNode {
  /** Gets a valid completion for this non-returning call. */
  abstract Completion getACompletion();
}

private class RaiseCall extends NonReturningCall, MethodCall {
  RaiseCall() { this.getMethod().toString() = "raise" }

  override RaiseCompletion getACompletion() { any() }
}

private class ExitCall extends NonReturningCall, MethodCall {
  ExitCall() { this.getMethod().toString() in ["abort", "exit"] }

  override ExitCompletion getACompletion() { any() }
}
