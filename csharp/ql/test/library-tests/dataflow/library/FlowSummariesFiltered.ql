import shared.FlowSummaries

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
      rsc.isAbstractOrInterface() and
      this.(Virtualizable).overridesOrImplementsOrEquals(rsc) and
      rsc.propagatesFlow(input, output, preservesValue)
    )
  }
}
