import shared.FlowSummaries
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate::Csv
private import semmle.code.csharp.dataflow.ExternalFlow

class IncludeFilteredSummarizedCallable extends IncludeSummarizedCallable {
  IncludeFilteredSummarizedCallable() { this instanceof SummarizedCallable }

  /**
   * Holds if flow is propagated between `input` and `output` and
   * if there is no summary for a callable in a `base` class or interface
   * that propagates the same flow between `input` and `output`.
   */
  override predicate relevantSummary(
    SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
  ) {
    this.propagatesFlow(input, output, preservesValue) and
    not exists(IncludeSummarizedCallable rsc |
      isBaseCallableOrPrototype(rsc) and
      rsc.propagatesFlow(input, output, preservesValue) and
      this.(UnboundCallable).overridesOrImplementsUnbound(rsc)
    )
  }
}
