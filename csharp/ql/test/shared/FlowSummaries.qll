import semmle.code.csharp.dataflow.FlowSummary
import semmle.code.csharp.dataflow.internal.FlowSummaryImpl

/** A flow summary to include in the `summary/3` query predicate. */
abstract class RelevantSummarizedCallable extends SummarizedCallable {
  RelevantSummarizedCallable() {
    [this.(Modifiable), this.(Accessor).getDeclaration()].isEffectivelyPublic()
  }

  /** Holds if flow is propagated between `input` and `output`. */
  predicate relevantSummary(
    SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
  ) {
    this.propagatesFlow(input, output, preservesValue)
  }
}

/** Render the kind in the format used in flow summaries. */
private string renderKind(boolean preservesValue) {
  preservesValue = true and result = "value"
  or
  preservesValue = false and result = "taint"
}

/**
 * A query predicate for outputting flow summaries in semi-colon separated format in QL tests.
 * The syntax is: "namespace;type;overrides;name;signature;ext;inputspec;outputspec;kind",
 * ext is hardcoded to empty.
 */
query predicate summary(string csv) {
  exists(
    RelevantSummarizedCallable c, SummaryComponentStack input, SummaryComponentStack output,
    boolean preservesValue
  |
    c.relevantSummary(input, output, preservesValue) and
    csv =
      c.asPartialModel() + ";" + Public::getComponentStackCsv(input) + ";" +
        Public::getComponentStackCsv(output) + ";" + renderKind(preservesValue)
  )
}
