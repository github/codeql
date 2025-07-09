/** A model for `clone` on the `Clone` trait. */

private import rust
private import codeql.rust.dataflow.FlowSummary

/** A `clone` method. */
final class CloneCallable extends SummarizedCallable::Range {
  CloneCallable() {
    this.getParamList().hasSelfParam() and
    this.getParamList().getNumberOfParams() = 0 and
    this.getName().getText() = "clone"
  }

  final override predicate propagatesFlow(
    string input, string output, boolean preservesValue, string model
  ) {
    input = "Argument[self].Reference" and
    output = "ReturnValue" and
    preservesValue = true and
    model = "generated"
  }
}
