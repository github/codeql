/** A model for `clone` on the `Clone` trait. */

private import rust
private import codeql.rust.dataflow.FlowSummary

/** A `clone` method. */
final class CloneCallable extends SummarizedCallable::Range {
  CloneCallable() {
    // NOTE: The function target may not exist in the database, so we base this
    // on method calls.
    exists(MethodCallExpr c |
      c.getIdentifier().getText() = "clone" and
      c.getArgList().getNumberOfArgs() = 0 and
      this = c.getResolvedCrateOrigin() + "::_::" + c.getResolvedPath()
    )
  }

  final override predicate propagatesFlow(
    string input, string output, boolean preservesValue, string model
  ) {
    input = "Argument[self]" and
    output = "ReturnValue" and
    preservesValue = true and
    model = "generated"
  }
}
