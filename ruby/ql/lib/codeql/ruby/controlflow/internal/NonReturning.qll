/** Provides a simple analysis for identifying calls that will not return. */
overlay[local]
module;

private import codeql.ruby.AST
private import codeql.controlflow.SuccessorType

/** A call that definitely does not return (conservative analysis). */
abstract class NonReturningCall extends MethodCall {
  /** Gets a valid successor type for this non-returning call. */
  abstract AbruptSuccessor getASuccessorType();
}

private class RaiseCall extends NonReturningCall {
  RaiseCall() { this.getMethodName() = "raise" }

  override ExceptionSuccessor getASuccessorType() { any() }
}

private class ExitCall extends NonReturningCall {
  ExitCall() { this.getMethodName() in ["abort", "exit"] }

  override ExitSuccessor getASuccessorType() { any() }
}
