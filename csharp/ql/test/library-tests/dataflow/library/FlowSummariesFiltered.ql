import shared.FlowSummaries
private import semmle.code.csharp.dataflow.internal.ExternalFlow

module TestSummaryInput implements TestSummaryInputSig {
  class RelevantSummarizedCallable = IncludeSummarizedCallable;
}

import TestSummaryOutput<TestSummaryInput>

class IncludeFilteredSummarizedCallable extends RelevantSummarizedCallable {
  /**
   * Holds if flow is propagated between `input` and `output` and
   * if there is no summary for a callable in a `base` class or interface
   * that propagates the same flow between `input` and `output`.
   */
  override predicate relevantSummary(
    SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
  ) {
    this.(SummarizedCallableImpl).propagatesFlow(input, output, preservesValue) and
    not exists(IncludeSummarizedCallable rsc |
      isBaseCallableOrPrototype(rsc) and
      rsc.(SummarizedCallableImpl).propagatesFlow(input, output, preservesValue) and
      this.(UnboundCallable).overridesOrImplementsUnbound(rsc)
    )
  }
}
