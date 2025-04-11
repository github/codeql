/** A model for `clone` on the `Clone` trait. */

private import rust
private import codeql.rust.dataflow.FlowSummary

/** A `clone` method. */
final class CloneCallable extends SummarizedCallable::Range {
  CloneCallable() {
    this.getParamList().getNumberOfParams() = 0 and
    this.getName().getText() = "clone"
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

private predicate sdf(MethodCallExpr c, string s, Addressable a) {
  c.getIdentifier().getText() = "clone" and
  c.getArgList().getNumberOfArgs() = 0 and
  s = c.getResolvedPath() and
  s = a.getExtendedCanonicalPath()
}
